import os
import sys
import hashlib


def get_md5(file_path, chunk_size=8192):
    """计算文件的 MD5 哈希值"""
    md5 = hashlib.md5()
    with open(file_path, 'rb') as f:
        while True:
            data = f.read(chunk_size)
            if not data:
                break
            md5.update(data)
    return md5.hexdigest()


def remove_duplicate_images(folder_path):
    """删除重复图片，保留第一个找到的文件"""
    md5_dict = {}
    removed_count = 0
    kept_count = 0

    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                md5 = get_md5(file_path)
                if md5 in md5_dict:
                    os.remove(file_path)
                    print(f"Removed: {file_path}")
                    removed_count += 1
                else:
                    md5_dict[md5] = file_path
                    kept_count += 1
            except (PermissionError, OSError) as e:
                print(f"Skipped: {file_path} ({e})")

    print(f"\nDone. Kept: {kept_count}, Removed: {removed_count}")


if __name__ == '__main__':
    folder_path = sys.argv[1] if len(sys.argv) > 1 else '.'
    if not os.path.isdir(folder_path):
        print(f"Error: '{folder_path}' is not a valid directory")
        sys.exit(1)
    print(f"Scanning: {folder_path}")
    remove_duplicate_images(folder_path)
