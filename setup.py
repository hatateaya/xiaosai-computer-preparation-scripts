import ctypes
import sys
import os
import subprocess
import traceback

def is_user_admin():
    """
    检查当前是否以管理员权限运行
    Return:
        True: 管理员权限
        False: 普通用户权限
    """
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except:
        traceback.print_exc()
        return False

def elevate():
    """
    提升程序权限至管理员权限
    """
    if not is_user_admin():
        script_path = os.path.abspath(sys.argv[0])
        
        # 以管理员权限重新运行程序
        params = ' '.join(['"{}"'.format(arg) for arg in sys.argv])
        try:
            ctypes.windll.shell32.ShellExecuteW(
                None,                # 父窗口句柄
                "runas",             # 操作：请求管理员权限
                sys.executable,      # Python解释器路径
                f'"{script_path}" {params}',  # 脚本路径和参数
                None,                # 工作目录
                1                    # 显示窗口
            )
        except Exception as e:
            print(f"请求权限提升失败: {str(e)}")
            sys.exit(1)
        else:
            print("正在请求管理员权限...请在弹出的UAC对话框中点击'是'")
            sys.exit(0)

def copyjson():
    configPath = os.path.join(os.getenv('APPDATA'), "VSCodium", "User")
    jsonPath = os.path.join(configPath, "settings.json")
    if not os.path.exists(configPath):
        os.mkdir(configPath)
    print(f"from {os.path.join(os.getcwd(), 'settings.json')} to {jsonPath}")
    with open(jsonPath, "w+") as setting, open("settings.json", "r") as f:
        for line in f.readlines():
            setting.write(line)
    print('拷贝成功！')

def run_batch_commands():
    """
    执行所有配置批处理命令
    """
    commands = [
        "configure_firewall.bat",
        "configure_path.bat",
        "configure_exts.bat",
        "configure_shortcut.bat"
    ]
    
    print("开始执行配置操作...")
    
    for idx, cmd in enumerate(commands):
        print(f"\n [{idx+1}/4] 正在执行: {cmd}\n")
        #print("-" * 50)
        os.system(cmd)
        '''try:
            # 使用subprocess.run确保能获取退出代码
            result = subprocess.run(
                ["cmd.exe", "/c", cmd],
                check=True,
                text=True,
                capture_output=True
            )
            print(result.stdout)
            print(f"✅ 命令执行成功!")
        except subprocess.CalledProcessError as e:
            print(f"❌ 执行失败: {cmd}")
            print(f"错误信息: {e.stderr}")
            print(f"返回代码: {e.returncode}")'''
        #print("-" * 50)


def main():
    #print("=" * 60)
    #print("系统配置工具")
    #print("=" * 60)
    
    # 请求管理员权限
    elevate()
    
    # 如果是管理员则执行配置
    if is_user_admin():
        try:
            run_batch_commands()
            copyjson()
            print("\n所有配置已完成!")
        except Exception as e:
            print(f"配置过程中出现错误: {str(e)}")
            traceback.print_exc()
        
        # 添加暂停以便查看结果
        input("\n按回车键退出程序...")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n操作已取消")
    except Exception as e:
        print(f"程序运行出错: {str(e)}")
        traceback.print_exc()
        input("按回车键退出...")
