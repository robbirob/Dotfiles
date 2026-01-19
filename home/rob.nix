{ config, pkgs, ... }:

{
	home.stateVersion = "25.11";
	home.sessionVariables = {
		EDITOR = "nvim";
		VISUAL = "nvim";
	};
	wayland.windowManager.sway = {
		enable = true;
		config = rec {
			modifier = "Mod4";
			terminal = "${pkgs.kitty}/bin/kitty";
			menu = "${pkgs.bemenu}/bin/bemenu-run";
						
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
		#profiles = {
		#	rob = {};
		#};
	};
	programs.git.enable = true;
	programs.neovim = {
		enable = true;
		viAlias = true;
		vimAlias = true;
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
}
