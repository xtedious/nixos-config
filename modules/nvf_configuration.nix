{
  pkgs,
  lib,
  ...
}: {
  vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    ui.colorizer = {
      enable = true;
      setupOpts.filetypes = {
        "*" = {};
      };
    };

    filetree = {
      neo-tree.enable = true;
    };

    git.enable = true;
    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      clang.enable = true;
      python.enable = true;
      rust.enable = true;
    };

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    options = {
      shiftwidth = 2;
      tabstop = 2;
    };

    useSystemClipboard = true;
  };
}
