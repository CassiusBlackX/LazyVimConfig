return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {}, -- 让 LazyVim 自动传入 opts，避免重复定义
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    local Rule = require("nvim-autopairs.rule")

    -- 1️⃣ 禁用 Rust 文件中的单引号补全
    npairs.add_rules({
      Rule("'", "'"):with_pair(function()
        return vim.bo.filetype ~= "rust"
      end),
    })

    -- 2️⃣ Rust 中的 <...> 支持 > 跳出闭合
    npairs.add_rules({
      Rule("<", ">", "rust"),

      Rule(">", ">", "rust")
        :with_pair(function()
          return false
        end)
        :with_move(function(opts)
          return opts.char == ">"
        end)
        :use_key(">"),
    })
  end,
}
