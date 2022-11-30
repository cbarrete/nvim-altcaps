local M = {}

M.upper = true
M.lower = false

M.config = {
    l = M.upper,
    i = M.lower,
}

local not_whitespace_regex = vim.regex('\\S')

M.operatorfunc = function(motion)
    -- motion is 'line', 'char' or 'block'
    assert(motion ~= 'block', 'block selection is not supported yet')

    local b = vim.api.nvim_buf_get_mark(0, '[')
    local e = vim.api.nvim_buf_get_mark(0, ']')

    local text
    if motion == 'line' then
        text = vim.api.nvim_buf_get_lines(0, b[1] - 1 , e[1], true)
    else
        text = vim.api.nvim_buf_get_text(0, b[1] - 1, b[2], e[1] - 1, e[2] + 1, {})
    end

    local output = {}
    local capitalize = false
    for _, line in pairs(text) do
        local new_line = ''

        local idx = 1
        while idx <= #line do
            local utf_start = vim.str_utf_start(line, idx)
            local utf_end = vim.str_utf_end(line, idx)

            local char = line:sub(idx + utf_start, idx + utf_end)
            if not_whitespace_regex:match_str(char) then
                local lower_char = vim.fn.tolower(char)

                local forced = M.config[lower_char]
                if forced ~= nil then
                    capitalize = forced
                end

                if capitalize then
                    char = vim.fn.toupper(char)
                    capitalize = false
                else
                    char = lower_char
                    capitalize = true
                end
            end
            new_line = new_line .. char

            idx = idx + utf_end + 1
        end
        table.insert(output, new_line)
    end

    if motion == 'line' then
        text = vim.api.nvim_buf_set_lines(0, b[1] - 1 , e[1], true, output)
    else
        text = vim.api.nvim_buf_set_text(0, b[1] - 1, b[2], e[1] - 1, e[2] + 1, output)
    end
end

M.operator = function()
    vim.o.operatorfunc = "v:lua.require'altcaps'.operatorfunc"
    return 'g@'
end

M.setup = function(config)
    if config then
        for k, v in pairs(config) do
            M.config[vim.fn.tolower(k)] = v
        end
    end
end

return M
