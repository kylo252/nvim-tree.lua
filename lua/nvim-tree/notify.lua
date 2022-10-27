local has_notify, notify = pcall(require, "notify")

local M = {}

local current_level = vim.log.levels.INFO

local function should_notify(level)
  return level >= current_level
end

local function dispatch(level)
  if not should_notify(level) then
    return
  end
  return function(msg)
    vim.schedule(function()
      if has_notify and notify then
        notify(msg, level, { title = "NvimTree" })
      else
        vim.notify("[NvimTree] " .. msg, level)
      end
    end)
  end
end

M.warn = dispatch(vim.log.levels.WARN)
M.error = dispatch(vim.log.levels.ERROR)
M.info = dispatch(vim.log.levels.INFO)
M.debug = dispatch(vim.log.levels.DEBUG)

function M.setup(opts)
  opts = opts or {}
  current_level = opts.default_level or vim.log.levels.INFO
end

return M
