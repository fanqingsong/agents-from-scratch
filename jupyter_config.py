c = get_config()

# 允许所有来源访问
c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.token = ''
c.NotebookApp.password = ''

# 允许根用户运行
c.NotebookApp.allow_root = True

# 禁用 CSRF 检查（仅用于开发环境）
c.NotebookApp.disable_check_xsrf = True

# 设置工作目录
c.NotebookApp.notebook_dir = '/app'

# 自动保存
c.FileContentsManager.use_atomic_writing = True

# 扩展配置
c.NotebookApp.nbserver_extensions = {
    'jupyter_nbextensions_configurator': True,
}

# 内核配置
c.KernelManager.shutdown_wait_time = 5.0
c.KernelManager.cleanup_resources = True



