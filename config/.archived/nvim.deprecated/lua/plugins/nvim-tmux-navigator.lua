return {
  "christoomey/vim-tmux-navigator",
  vim.keymap.set('n', 'C-M-h', ':TmuxNavigateLeft<CR>'),
  vim.keymap.set('n', 'C-M-j', ':TmuxNavigateDown<CR>'),
  vim.keymap.set('n', 'C-M-k', ':TmuxNavigateUp<CR>'),
  vim.keymap.set('n', 'C-M-l', ':TmuxNavigateRight<CR>'),
}
