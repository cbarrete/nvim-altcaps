local M = {}

M.config = {
    always_upper = { 'L' },
    always_lower = { 'i' },
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
            local lower_char = vim.fn.tolower(char)
            local upper_char = vim.fn.toupper(char)

            if not_whitespace_regex:match_str(char) then
                if vim.tbl_contains(M.config.always_upper, upper_char) then
                    char = upper_char
                    capitalize = false
                elseif vim.tbl_contains(M.config.always_lower, lower_char) then
                    char = lower_char
                    capitalize = true
                elseif capitalize then
                    char = upper_char
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

return M
