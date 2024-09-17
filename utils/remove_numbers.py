import re

def remove_trailing_numbers(file_path):
    # Đọc nội dung file
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.readlines()

    # Loại bỏ số ở cuối mỗi dòng nhưng giữ lại ký tự xuống dòng
    cleaned_content = [re.sub(r'\s*\d+\s*$', '\n', line) for line in content]

    # Ghi lại nội dung đã xử lý vào file
    with open(file_path, 'w', encoding='utf-8') as file:
        file.writelines(cleaned_content)

    return "Các số cuối dòng đã được xóa và giữ lại xuống dòng."
