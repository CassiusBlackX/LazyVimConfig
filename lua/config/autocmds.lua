-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- auto save when losing focus of the current buffer and notify
local function auto_save_and_notify()
  vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    group = vim.api.nvim_create_augroup("AutoSaveAndNotify", { clear = true }),
    callback = function()
      -- check if writable
      if vim.bo.buftype == "" and vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly then
        vim.cmd("w")
        vim.notify("Buffer save automatically", vim.log.levels.INFO, { title = "Auto Save" })
      end
    end,
  })
end
auto_save_and_notify()

-- save every modified buffer every ten minutes
local function periodic_auto_save()
  local function save_all_modified_buffers()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
        if buftype == "" and modified then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("w")
          end)
          vim.notify("All modified buffers saved automatically", vim.log.levels.INFO, { title = "Periodic Auto Save" })
        end
      end
    end
    -- 安排下一次保存
    vim.defer_fn(save_all_modified_buffers, 600000)
  end
  -- 启动周期性保存
  vim.defer_fn(save_all_modified_buffers, 600000)
end

periodic_auto_save()
