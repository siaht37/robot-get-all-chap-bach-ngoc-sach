*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    utils/parse_chapters.py
Library    utils/remove_numbers.py
Library    JSONLibrary 
Library    Collections
Test Teardown    Close All Browsers

*** Variables ***
${URL_PAGE_OF_CONTENTS}    https://bachngocsach.com.vn/reader/quang-am-chi-ngoai-convert/muc-luc?page=all
${FILE_PATH_CHAPTER_URL_LIST}    quang-am-chi-ngoai/a-list-chap-url-quang-am-chi-ngoai.txt
${FILE_PATH_CURRENT_CHAPTER}    quang-am-chi-ngoai/a-current-chap.txt
${PREFIX_URL}    https://bachngocsach.com.vn
${FILE_PATH_PREFIX}    quang-am-chi-ngoai/quang-am-chi-ngoai-

*** Test Cases ***
# BachNgocSach Get 1 chap
#     ${url}=    Set Variable    https://bachngocsach.com.vn/reader/quan-am-chi-ngoai-convert/awmp       
#     ${file_path}=    Set Variable    quang-am-chi-ngoai/quang-am-chi-ngoai-chap-1.txt
#     Open Browser    ${url}    firefox
#     Wait Until Element Is Visible    noi-dung
#     ${content}=    Get Text    noi-dung
#     Create File    ${file_path}    ${content}
#     ${result}    Remove Trailing Numbers    ${file_path}
#     Log    ${result}

Get Chapter URL List
    Open Browser    ${URL_PAGE_OF_CONTENTS}    firefox
    Wait Until Element Is Visible    mucluc-list
    ${html}=    Get Source
    ${chapters}=    Extract Chapters    ${html}
    ${chapters_str}=    Convert To Json    ${chapters}
    Create File    ${FILE_PATH_CHAPTER_URL_LIST}    ${chapters_str}
    Log    ${chapters_str}
   

# BachNgocSach get all chapter
#     ${chapters}=    Read JSON File    ${FILE_PATH_CHAPTER_URL_LIST}
#     ${chapters_length}=    Get Length    ${chapters}

#     FOR    ${index}    IN RANGE    ${chapters_length}
#         ${chapter}=    Get From List    ${chapters}    ${index}
#         ${chap_url_array}=    Get Value From Json    ${chapter}    url
#         ${chap_title_array}=    Get Value From Json    ${chapter}    chap
#         ${chap_number}=    Evaluate    ${index}+1
#         ${chap_name}=    Catenate    chap-${chap_number}
#         ${chap_url}=    Get From List    ${chap_url_array}    0
#         ${chap_title}=    Get From List    ${chap_title_array}    0
#         ${full_url}=    Set Variable    ${PREFIX_URL}${chap_url}
#         ${file_path}=    Set Variable    ${FILE_PATH_PREFIX}${chap_name}.txt
#         Open Browser    ${full_url}    firefox
#         Wait Until Element Is Visible    noi-dung
#         ${content}=    Get Text    noi-dung

#         # Tạo nội dung với dòng đầu tiên là tên chương
#         ${file_content}=    Catenate    SEPARATOR=\n    ${chap_title}    ${content}
        
#         Create File    ${file_path}    ${file_content}
#         ${result}=    Remove Trailing Numbers    ${file_path}
#         Log    ${result}
#         Close Browser
#     END
Trigger new chapters
    #get current length of list chap from file
    ${current_length}=    Get File    ${FILE_PATH_CURRENT_CHAPTER}
    ${current_index}=    Evaluate    ${current_length}

    #get array list url chap
    ${chapters}=    Read JSON File    ${FILE_PATH_CHAPTER_URL_LIST}
    ${chapters_length}=    Get Length    ${chapters}

    #loop to get new chaps
    FOR    ${index}    IN RANGE    ${current_index}    ${chapters_length}
        ${chapter}=    Get From List    ${chapters}    ${index}
        ${chap_url_array}=    Get Value From Json    ${chapter}    url
        ${chap_title_array}=    Get Value From Json    ${chapter}    chap
        ${chap_number}=    Evaluate    ${index}+1
        ${chap_name}=    Catenate    chap-${chap_number}
        ${chap_url}=    Get From List    ${chap_url_array}    0
        ${chap_title}=    Get From List    ${chap_title_array}    0
        ${full_url}=    Set Variable    ${PREFIX_URL}${chap_url}
        ${file_path}=    Set Variable    ${FILE_PATH_PREFIX}${chap_name}.txt
        Open Browser    ${full_url}    firefox
        Wait Until Element Is Visible    noi-dung
        ${content}=    Get Text    noi-dung

        # Tạo nội dung với dòng đầu tiên là tên chương
        ${file_content}=    Catenate    SEPARATOR=\n    ${chap_title}    ${content}
        
        Create File    ${file_path}    ${file_content}
        ${result}=    Remove Trailing Numbers    ${file_path}
        Log    ${result}
        Close Browser
        ${current_length}=    Evaluate    ${current_length}+1
    END

    # ${current_length}=    Evaluate    ${current_length}
    ${current_length_str}=    Convert To String    ${current_length}
    Create File    ${FILE_PATH_CURRENT_CHAPTER}    ${current_length_str}

*** Keywords ***
Read JSON File
    [Arguments]    ${file_path}
    ${file_content}=    Load Json From File    ${file_path}    encoding=utf-8
    RETURN    ${file_content}
