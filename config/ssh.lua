local wezterm = require 'wezterm'
local ssh_config = {}

-- ==========================================
-- 1. 动态解析 .ssh/config 的函数
-- ==========================================
function ssh_config.get_hosts()
  local hosts = {}
  local home = os.getenv("USERPROFILE") or os.getenv("HOME")
  local ssh_config_path = home .. "/.ssh/config"

  -- 尝试打开文件
  local file = io.open(ssh_config_path, "r")
  if not file then
    return hosts -- 如果找不到文件，返回空表，不影响正常启动
  end

  for line in file:lines() do
      -- 1. 去掉每一行前后的空白字符（缩进）
      local trimmed = line:match("^%s*(.-)%s*$")
      
      -- 2. 确保这一行不是以 # 开头的注释行
      if trimmed and not trimmed:match("^#") then
        -- 3. 严格匹配以 Host 单词开头的行，%s+ 匹配一个或多个空格
        --    这样可以完美过滤掉带有 "Host" 字眼的注释或子属性（如 "# LocalForward" 或 "HostName"）
        local host = trimmed:match("^[Hh][Oo][Ss][Tt]%s+(%S+)")
        
        -- 4. 排除全局通配符，并将有效 Host 注入数组
        if host and not host:match("%*") then
          table.insert(hosts, host)
        end
      end
    end
  file:close()
  return hosts
end

return ssh_config