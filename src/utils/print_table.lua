--- Print tables recursively (safe against cycles)
---@param tbl table
---@return nil
local function print_table(tbl)
  local function _tprint(t, indent, visited)
    if type(t) ~= 'table' then
      print(indent .. tostring(t))
      return
    end

    if visited[t] then
      print(indent .. '<cycle>')
      return
    end

    visited[t] = true

    -- detect array-like tables so we print numeric indices in order
    local is_array = true
    local max_i = 0
    for k in pairs(t) do
      if type(k) ~= 'number' then
        is_array = false
        break
      end
      if k > max_i then max_i = k end
    end

    if is_array and max_i > 0 then
      for i = 1, max_i do
        local v = t[i]
        if type(v) == 'table' then
          print(string.format('%s[%d] = {', indent, i))
          _tprint(v, indent .. '  ', visited)
          print(indent .. '}')
        else
          print(string.format('%s[%d] = %s', indent, i, tostring(v)))
        end
      end
    else
      for k, v in pairs(t) do
        local key = tostring(k)
        if type(v) == 'table' then
          print(string.format('%s%s = {', indent, key))
          _tprint(v, indent .. '  ', visited)
          print(indent .. '}')
        else
          print(string.format('%s%s = %s', indent, key, tostring(v)))
        end
      end
    end
  end

  -- surround the whole output with brackets and indent contents
  print '{'
  _tprint(tbl, '  ', {})
  print '}'
end

return print_table
