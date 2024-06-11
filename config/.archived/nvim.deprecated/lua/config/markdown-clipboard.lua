-- Function to insert Markdown image link
function MarkdownClipboardImage()
  -- Get the directory of the currently opened file
  local current_dir = vim.fn.expand('%:p:h')

  -- Create `img` directory if it doesn't exist in the current directory
  local img_dir = current_dir .. '/img'
  if vim.fn.isdirectory(img_dir) == 0 then
    local success = vim.fn.mkdir(img_dir, 'p')
    if success ~= 0 then
      print("Error creating img directory")
      return
    end
  end

  -- Find a suitable filename
  local index = 1
  local file_path = img_dir .. '/image' .. index .. '.png'
  while vim.fn.filereadable(file_path) == 1 do
    index = index + 1
    file_path = img_dir .. '/image' .. index .. '.png'
  end

  -- Construct the command to get PNG data from clipboard and write to file
  local clip_command = 'osascript'
  clip_command = clip_command .. ' -e "try"'
  clip_command = clip_command .. ' -e "set png_data to the clipboard as «class PNGf»"'
  clip_command = clip_command .. ' -e "set referenceNumber to open for access POSIX path of'
  clip_command = clip_command .. ' (POSIX file \'' .. file_path .. '\') with write permission"'
  clip_command = clip_command .. ' -e "write png_data to referenceNumber"'
  clip_command = clip_command .. ' -e "close access referenceNumber"'
  clip_command = clip_command .. ' -e "end try"'

  -- Execute the command
  local status = vim.fn.system(clip_command)

  -- Check if execution was successful
  if status == 0 then
    -- Insert Markdown image link at the cursor position
    vim.api.nvim_command('execute "normal! i[](' .. file_path .. ')"')
  else
    -- If execution failed, paste clipboard content as normal text
    print("Error executing clipboard command")
    vim.api.nvim_command('normal! p')
  end
end

-- Define the mapping in Lua
vim.keymap.set('n', '<leader>pp', [[:lua MarkdownClipboardImage()<CR>]], { noremap = true, silent = true })

