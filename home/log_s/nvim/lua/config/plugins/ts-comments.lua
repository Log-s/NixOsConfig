-- Comment.nvim configuration with ts-context-commentstring integration
local comment = require("Comment")

-- Only set up the pre_hook if ts_context_commentstring is available
local ok, ts_context_commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
if ok then
  comment.setup({
    pre_hook = ts_context_commentstring.create_pre_hook(),
  })
else
  -- Fallback if ts-context-commentstring isn't loaded yet
  comment.setup({})
end

