import os
import hashlib

def get_md5(file_path):
    md5 = hashlib.md5()
    with open(file_path, 'rb') as f:
        while True:
            data = f.read(1024)
            if not data:
                break
            md5.update(data)
    return md5.hexdigest()

def remove_duplicate_images(folder_path):
    md5_dict = {}
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            md5 = get_md5(file_path)
            if md5 in md5_dict:
                os.remove(file_path)
                print(f"Removed {file_path}")
            else:
                md5_dict[md5] = file_path

if __name__ == '__main__':
    folder_path = '.'
    remove_duplicate_images(folder_path)