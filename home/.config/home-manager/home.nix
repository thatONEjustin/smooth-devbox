{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "justinprime";
  home.homeDirectory = "/home/justinprime";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    gnome.gnome-themes-extra
    gnomeExtensions.gtk3-theme-switcher
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  # };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/justinprime/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    ll = "ls -lah $1";
    nedit = "cd $HOME/Documents/github/smooth-devbox/etc/nixos && nvim $1 ./configuration.nix";
    nrebuild = "sudo nixos-rebuild switch -I nixos-config=$HOME/Documents/github/smooth-devbox/etc/nixos/configuration.nix";
    ngarbage = "sudo nix-collect-garbage --delete-old";
    nhomedit = "cd $HOME/Documents/github/smooth-devbox/home/.config/home-manager/ && nvim $1 ./home.nix $2";
    nhomeup = "home-manager switch -f $HOME/Documents/github/smooth-devbox/home/.config/home-manager/home.nix";
    githubd = "cd $HOME/Documents/github";
    workd = "cd $HOME/Documents/work";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 20;
          y = 20;
        };
      };
    };
  };

 programs.tmux = {
     enable = true;
     keyMode = "vi";
     baseIndex = 1;
     mouse = true;
     newSession = true;
     shortcut = "Space";
     terminal = "tmux-256color";
     plugins =  with pkgs.tmuxPlugins; [
         sensible
         vim-tmux-navigator
         catppuccin
     ];
     sensibleOnTop = true;
     extraConfig = ''
       set-option -ga terminal-overrides ",*:Tc"

       set -g @catppuccin_flavour 'latte'

       bind '"' split-window -h -c "#{pane_current_path}"
       bind % split-window -v -c "#{pane_current_path}"
     '';
};


  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "fletcherm";
      plugins = [ "tmux" "git" "docker" ];
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      telescope-nvim
      nvim-treesitter.withAllGrammars
      lsp-zero-nvim

      rose-pine
      melange-nvim
    ];
  };

  xdg.configFile."nvim/init.lua".text = ''
    require("smoothverse")
  '';

  xdg.configFile."nvim/lua/smoothverse/init.lua".text = ''
    require("smoothverse.set")
    require("smoothverse.remap")
  '';
  
  xdg.configFile."nvim/lua/smoothverse/remap.lua".text = ''
    vim.g.mapleader = " ";

    vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>");
    vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>");
    vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>");
    vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>");
  '';

  xdg.configFile."nvim/lua/smoothverse/set.lua".text = ''
    vim.opt.nu = true
    vim.opt.relativenumber = true

    vim.opt.wrap = false

    vim.opt.hlsearch = false
    vim.opt.incsearch = true

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true

    vim.opt.smartindent = true
    
    vim.opt.termguicolors = true
  '';

  xdg.configFile."nvim/after/plugin/telescope.lua".text = ''
    local builtin = require('telescope.builtin')
    
    vim.keymap.set("n", "<leader>ff", builtin.find_files, {});
    vim.keymap.set("n", "<C-p>", builtin.git_files, {});
    vim.keymap.set("n", "<leader>ps", function() 
      builtin.grep_string({ search = vim.fn.input("Grep > ") });
    end);
  '';


#  require('rose-pine').setup({
#      variant = 'moon',
#      disable_background = true
#  })
#  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
#  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


  xdg.configFile."nvim/after/plugin/colors.lua".text = ''
    require('rose-pine').setup({
        disable_background = true
    })

    function ColorNvim(color)
      color = color or "rose-pine"
      vim.cmd.colorscheme(color)

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end

    ColorNvim()
  '';

  xdg.configFile."nvim/after/plugin/treesitter.lua".text = ''
    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true,
        },

        indent = {
            enable = true,
        },
    }
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
