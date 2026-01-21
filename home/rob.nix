{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.sessionPath = [ "$HOME/.opencode/bin" ];
  home.packages = with pkgs; [
    wl-clipboard
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.bemenu}/bin/bemenu-run";

      seat = {
        "*" = {
          # timeout in milliseconds as a string
          hide_cursor = "2000";
        };
      };

      input = {
        "*" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
        };
      };
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+e" = "exec swaymsg exit";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
      };
    };
  };
  programs.waybar.enable = true;
  programs.firefox = {
    enable = true;
    profiles = {
      rob = {};
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "Robert Freese";
      user.email = "robbirob@gmail.com";
    };
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # LSP Server + Formatter
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp

      # Treesitter (Syntax Highlighting)
      nvim-treesitter.withAllGrammars
    ];

    extraLuaConfig = ''
      -- Completion
      local cmp = require('cmp')
      cmp.setup({
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'nvim_lsp' },
        },
      })

      -- LSP capabilities for completion
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Treesitter (optional, aber empfehlenswert)
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
      })

      -- nixd (mit NixOS-Options-Completion via deiner Flake)
      local flakePath = "/home/rob/dotfiles"

      vim.lsp.config('nixd', {
        capabilities = capabilities,
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake "' .. flakePath .. '").nixosConfigurations.thinkpad.options',
              },
            },
          },
        },
      })
      vim.lsp.enable('nixd')
      vim.g.mapleader = " "
      vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })
    '';
  };
  programs.kitty.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#thinkpad";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "history"
        "extract"
        "colored-man-pages"
      ];
    };
  };
  services.mako.enable = true;

  stylix.targets.neovim.enable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.sway.enable = true;
  stylix.targets.firefox.profileNames = [ "rob" ];
}
