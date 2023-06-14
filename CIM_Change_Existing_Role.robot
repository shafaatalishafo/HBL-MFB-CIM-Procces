

# *** Keywords ***
# Get tickets from CIM identify ticket and work on FlexCube
#     Click element    //a[@href="/CIM/RequestsInbox/"]
#     Sleep    5s 
#     ${tickets}   Get Element Count    //table[contains(@class,"table")]/tbody/tr/td[3]/b
#     FOR  ${i}  IN RANGE  1  ${tickets}+1
#         ${START_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
#         Switch window   MAIN
#         ${ticket_type_text}  Get text   (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]
#         IF  '${ticket_type_text}' == 'Change of Existing Role In FlexCube'
#             Log  ${ticket_type_text}
#             ${id_in_CIM}   Get text  (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]/../../td[1]/b
#             Log  ${id_in_CIM}
#             Set global variable  ${TICKET_ID}  ${id_in_CIM}
#             Set global variable   ${ticket_type_text}  Change of Existing Role In FlexCube
#             Click element when visible    (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]/../../td[7]
#             Click element when visible    (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]/../../td[7]/select/option[contains(text(),'ammad.mm')]
#             Click element   (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]/../../td[9]/a
#             ${emp_id}  ${emp_name}  ${emp_roles}   ${emp_comment}   Get ticket texts from cim
#             log  ${emp_roles}
#             IF  'FMFB_SETTLEMENT_INSTRUCTION' in '${emp_roles}' or 'BATCH_UPLOAD-DEDUPONL' in '${emp_roles}' or 'FMFB_ACCOUNT_CLOSURE' in '${emp_roles}' or 'FMFB_CIF_CLOSURE' in '${emp_roles}' or 'FMFB_SIGNATURE_UPLOAD' in '${emp_roles}' or 'FMFB_COLLATERAL' in '${emp_roles}' or 'FMFB_REVERSAL_RIGHTS_DISBURSEMENT' in '${emp_roles}'
#                 IF  'LOV' in '${emp_comment}' or 'lov' in '${emp_comment}'
#                     Continue for loop
#                 END
#                 Open The Flexcube URL
#                 Login to Flexcube
#                 ${branch_code}   Search Details Query id and set function in flexcube      ${emp_roles}   ${emp_id}
#                 ${check_element_after_refresh}   Function id selction and assigning rights   ${emp_roles}    ${branch_code}
#                 ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
#                 Open Workbook    ${trace_file_name}
#                 Set Active Worksheet    Sheet
#                 ${table}   Read Worksheet As Table
#                 ${excel_len}   Get length  ${table}
#                 ${excel_len}   Evaluate   ${excel_len}+1
#                 Set Worksheet Value   ${excel_len}    1     ${emp_id}
#                 Set Worksheet Value   ${excel_len}    2     ${emp_name}
#                 Set Worksheet Value   ${excel_len}    3     ${emp_roles}
#                 Set Worksheet Value   ${excel_len}    4     ${emp_comment}
#                 Set Worksheet Value   ${excel_len}    5     ${id_in_CIM}
#                 IF  ${check_element_after_refresh} == False
#                     Set Worksheet Value   ${excel_len}    6     Ticket not found after reloading on CIM
#                 ELSE
#                     Set Worksheet Value   ${excel_len}    6     Ticket Resolved Sucessfully
#                 END
#                 Set Worksheet Value   ${excel_len}    7     ${START_TIME}
#                 Set Worksheet Value   ${excel_len}    8     ${END_TIME}
#                 Save Workbook
#             ELSE
#                 log  ticket not found
#             END
            
#         END
        
#     END

*** Keywords ***
Function id selction and assigning rights
    [Arguments]    ${emp_name}   ${emp_roles}    ${branch_code}    ${ticket_number}      ${emp_id}     ${emp_comment}    ${START_TIME}
    Click element when visible   //a[contains(text(),'Function')]
    IF  'FMFB_SETTLEMENT_INSTRUCTION' in '${emp_roles}'                                                                               #1
        Wait until page contains element    //iframe[contains (@title,'Function')]
        Select frame   //iframe[contains (@title,'Function')]
        Wait until page contains element    //button[@title="Add Row"]
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     ISDINSTN
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[7]/label/input        # Its for close
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[8]/label/input        # Its for unlock
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[9]/label/input        # Its for reopen
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     ISSINSTN
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[7]/label/input        # Its for close
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[8]/label/input        # Its for unlock
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[9]/label/input        # Its for reopen
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
    ELSE IF  'BATCH_UPLOAD-DEDUPONL' in '${emp_roles}'                                                                               #2
        Wait until page contains element    //iframe[contains (@title,'Function')]
        Select frame   //iframe[contains (@title,'Function')]
        Wait until page contains element    //button[@title="Add Row"]
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     DEDUPONL
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
    ELSE IF  'FMFB_ACCOUNT_CLOSURE' in '${emp_roles}'                                                                                   #3
        Wait until page contains element    //iframe[contains (@title,'Function')]
        Select frame   //iframe[contains (@title,'Function')]
        Wait until page contains element    //button[@title="Add Row"]
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     STDCUSAC
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[7]/label/input        # Its for close
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     STSCUSAC
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[7]/label/input        # Its for close
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
    ELSE IF  'FMFB_CIF_CLOSURE' in '${emp_roles}'                                                                                   #4
        Wait until page contains element    //iframe[contains (@title,'Function')]
        Select frame   //iframe[contains (@title,'Function')]
        Wait until page contains element    //button[@title="Add Row"]
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     STDCIF
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     STSCIF
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
    ELSE IF  'FMFB_SIGNATURE_UPLOAD' in '${emp_roles}'                                                                                   #5
        Wait until page contains element    //iframe[contains (@title,'Function')]
        Select frame   //iframe[contains (@title,'Function')]
        Wait until page contains element    //button[@title="Add Row"]
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     STDCIFIS
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[8]/label/input        # Its for unlock
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     STSCIFIS
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[8]/label/input        # Its for unlock
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
    ELSE IF  'FMFB_COLLATERAL' in '${emp_roles}'                                                                                   #6
        Wait until page contains element    //iframe[contains (@title,'Function')]
        Select frame   //iframe[contains (@title,'Function')]
        Wait until page contains element    //button[@title="Add Row"]
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     GEDCOLLT
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[7]/label/input        # Its for close
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     GESCOLLT
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[7]/label/input        # Its for close
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
    ELSE IF  'FMFB_REVERSAL_RIGHTS_DISBURSEMENT' in '${emp_roles}'                                                                                   #7
        Wait until page contains element    //iframe[contains (@title,'Function')]
        Select frame   //iframe[contains (@title,'Function')]
        Wait until page contains element    //button[@title="Add Row"]
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     MFDMNDSB
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[12]/label/input        # Its for reverse
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
        Click element when visible    //button[@title="Add Row"]
        Sleep   2s
        Click element   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[3]/button
        Sleep   2s
        Wait until page contains element    //iframe[contains (@title,'List of Values Function')]
        Select frame   //iframe[contains (@title,'List of Values Function')]
        Input text   //label[contains(text(),'Function Id')]/../input     MFSMNDSB
        Click element   //button[contains(text(),'Fetch Value')]
        Click element when visible    //*[contains(@summary,"List of Values Function")]/tbody/tr[1]/td[1]
        Sleep   3s
        ${contain_frame}   Does page contain element    //iframe[contains (@title,'Function')]  
        IF  ${contain_frame} == False
            Unselect frame
            Sleep    2s
            Select frame    (//iframe[contains(@title,'User Maintenance')])
            Select frame  (//iframe[@id="ifrSubScreen"])
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[12]/label/input        # Its for reverse
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
            Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate

        ELSE
            Select frame   //iframe[contains (@title,'Function')]
            Input text   //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[2]/input   ${branch_code}
        END
    ELSE
        Log  Ticket is not in our scope
        ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
        Update trace file role    ${emp_id}    ${emp_name}   ${emp_roles}    ${emp_comment}    ${ticket_number}   Ticket is not in our scope   ${START_TIME}   ${END_TIME}    Change existing role
        
    END
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[4]/label/input        # Its for new
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[5]/label/input        # Its for copy
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[6]/label/input        # Its for delete
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[7]/label/input        # Its for close
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[8]/label/input        # Its for unlock
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[9]/label/input        # Its for reopen
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[10]/label/input        # Its for print 
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[11]/label/input        # Its for auth
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[12]/label/input        # Its for reverse
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[13]/label/input        # Its for roleover component
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[14]/label/input        # Its for confirm
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[15]/label/input        # Its for 	Liquidate
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[16]/label/input        # Its for hold 
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[17]/label/input        # Its for temlate
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[18]/label/input        # Its for view
    # Click element    //table[@summary="User Stage Functions"]/tbody/tr[last()]/td[19]/label/input        # Its for generate


    Click element when visible    //input[contains(@value,"Ok")]
    Select frame    (//iframe[contains(@title,'User Maintenance')])  
    Click element when visible  //a[contains(text(),"Save")] 
    Wait until page contains element   //iframe[contains(@title,"Information Message")]
    Select frame  //iframe[contains(@title,"Information Message")]
    Click element when visible  //input[contains(@value,"Ok")]
    Unselect frame
    Wait until page contains element    //iframe[contains (@title,'User Maintenance')]
    Select frame    //iframe[contains (@title,'User Maintenance')]
    Click element when visible   //input[@id="BTN_EXIT_IMG"]
    Wait Until Page Contains Element  //iframe[contains (@title,'User Summary')]  20
    Select frame     //iframe[contains (@title,'User Summary')]
    Click element when visible   //input[@id="BTN_EXIT"]
    Click element when visible   //a[contains(text(),'Sign Off')]
    Wait until page contains element    //iframe[@id="ifr_AlertWin"]
    sleep  1s
    Unselect frame
    Sleep  2s
    Select frame   //iframe[@id="ifr_AlertWin"]
    Click element when visible  //*[contains(@title,"Ok")]
    ${check_element_after_refresh}   CIM_Change_Existing_Role.Resolve Ticket     ${emp_name}   ${emp_roles}   ${ticket_number}     ${emp_id}     ${emp_comment}    ${START_TIME}
    [Return]    ${check_element_after_refresh}

*** Keywords ***
Get ticket texts from cim
    Run Keyword And Ignore Error  Wait until page contains element     (//table)[2]     20s
    Sleep   1s
    ${emp_id}=   Get text   //div[@id="employeeId"]
    IF  '${emp_id}' == ''
        Sleep   3s
        Run Keyword And Ignore Error  Wait Until Keyword Succeeds  4x  4s  Handle alert   ACCEPT
    END
    Sleep    3s
    # Run keyword and return status   Handle alert   ACCEPT
    # Sleep   4s
    # Run keyword and return status   Handle alert   ACCEPT   
    Run Keyword And Ignore Error  Wait Until Keyword Succeeds  3x  2s  Handle alert   ACCEPT
    Run Keyword And Ignore Error  Wait Until Keyword Succeeds  3x  2s  Handle alert   ACCEPT
    Sleep  3s
    Wait until page contains element     //div[@id="employeeId"]      20s
    ${emp_id}   Get text   //div[@id="employeeId"] 
    ${emp_name}   Get text   //div[@id="employeeName"]
    ${emp_roles}   Get text   //div[@id="requestedRequests"]
    ${emp_comment}   Get text   //textarea[@id="userComments"]
    Set global variable  ${EMP_NAME}  ${emp_name}
    Set global variable  ${EMP_ROLES}  ${emp_roles}
    # Run keyword and return status   Handle Alert
    Sleep   0.5s
    Click element when visible   ((//table)[2]/../../../div/button)[1]
    [Return]   ${emp_id}  ${emp_name}  ${emp_roles}   ${emp_comment} 

*** Keywords ***
Update trace file role
    [Arguments]   ${emp_id}    ${emp_name}   ${emp_roles}    ${emp_comment}    ${id_for_xpath_row}   ${ticket_resolved_or_not}   ${START_TIME}   ${END_TIME}   ${ticket_sub}
    
    Open Workbook    ${Reporting_File}
    Set Active Worksheet    Sheet
    ${table}   Read Worksheet As Table
    ${excel_len}   Get length  ${table}
    ${excel_len}   Evaluate   ${excel_len}+1
    Set Worksheet Value   ${excel_len}    1     ${emp_id}
    Set Worksheet Value   ${excel_len}    2     ${emp_name}
    Set Worksheet Value   ${excel_len}    3     ${emp_roles}
    Set Worksheet Value   ${excel_len}    4     ${emp_comment}
    Set Worksheet Value   ${excel_len}    5     ${id_for_xpath_row} 
    Set Worksheet Value   ${excel_len}    6     ${ticket_resolved_or_not}
    Set Worksheet Value   ${excel_len}    7     ${START_TIME}
    Set Worksheet Value   ${excel_len}    8     ${END_TIME}
    Set Worksheet Value   ${excel_len}    9     ${ticket_sub}
    Set Worksheet Value   ${excel_len}    10    CBS
    Save Workbook  


*** Keywords ***
Search Details Query id and set function in flexcube  
    [Arguments]   ${emp_roles}  ${id}   ${emp_id}   ${emp_name}    ${emp_comment}    ${START_TIME} 
    Sleep   3s
    Input text when element is visible  (//input[@id='fastpath'])[1]   SMSUSRDF
    Click element when visible  (//span[@class='ICOgo'])[1]
    Select frame  (//*[@class="frames"])[1]
    Sleep    2s
    Input text when element is visible  //input[@label_value="User Identification"]    %${emp_id}
    Click element   //li[@id="Search"]/a
    Double click element   //table[@id="TBL_QryRslts"]/tbody/tr[1]/td[2]/a
    Unselect frame
    Sleep   4s
    Select frame  //iframe[contains (@title,'User Maintenance')]
    ${end_date_text}   Get Value   //label[contains(text(),'End Date')]/../input[2]
    Log  ${end_date_text}
    IF  "${end_date_text}" == "" 
        Click element when visible  //a[contains(text(),"Unlock")]
        Sleep    2s
        ${enabled_or_not}    Does page contain element   //b[contains(text(),'User Status')]/../div/label[1]/input[@label_value="Enabled"]
        IF   ${enabled_or_not} == True
            Log  Already enabled 
        ELSE
            # Select frame    //iframe[contains (@title,'User Maintenance')]
            Click element when visible    //b[contains(text(),'User Status')]/../div/label[1]/input
        END
        ${branch_code}    Get Value   //input[contains(@title,"Home Branch")]
        Log   ${branch_code}
        
    ELSE
        Click element when visible   //input[@id="BTN_EXIT_IMG"]
        Sleep   2s
        Wait until page contains element   //iframe[contains (@title,'Confirmation Message')]
        Select frame   //iframe[contains (@title,'Confirmation Message')]
        Click element when visible  //*[contains(@title,"Ok")]/..
        Sleep   2s
        ${if_not_exist}  Does page contain element  //h1[contains(text(),'User Maintenance')]/../div/a[1]
        IF  ${if_not_exist} == True
            Select frame    //iframe[contains (@title,'User Maintenance')]
            Sleep   2s
            Click element when visible   //h1[contains(text(),'User Maintenance')]/../div/a[1]
        END
        Wait until page contains element    //iframe[contains (@title,'User Summary')]
        Select frame     //iframe[contains (@title,'User Summary')]
        Click element when visible   //input[@id="BTN_EXIT"]
        Click element when visible   //a[contains(text(),'Sign Off')]
        Sleep   1.5s
        Select frame   //iframe[@id="ifr_AlertWin"]
        Click element when visible  //*[contains(@title,"Ok")]
        Unselect frame
        Close window
        Switch Window   MAIN
        Unassign the ticket     ${id} 
        ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
        Update trace file role    ${emp_id}    ${emp_name}   ${emp_roles}    ${emp_comment}    ${id}   End date is given so we do not resolve this ticket   ${START_TIME}   ${END_TIME}    Reset Password Flex Cube
        Log   Send Email
        send email  Exception Email  End Date is given on the CBS against this id ${id}. Kindly check at your own.    #  ${user_email}   ${ip_no}     ${port_no}    ${receiver}     ${cc_receiver} 
        # send email  Exception Email  End Date is given on the CBS against this id ${id}. Kindly check at your own.   ${user_email}   ${ip_no}     ${port_no}    ${receiver}     ${cc_receiver} 
    END
    [Return]   ${branch_code}

*** Keywords ***
Unassign the ticket 
    [Arguments]   ${ticket_number}
    Click element when visible    ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[7]/select)[${ticket_number}]
    Click element when visible    ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[7]/select/option[contains(text(),'Select Identity User')])[${ticket_number}]
    Sleep   2s 
    Run Keyword And Ignore Error   Click element when visible     (//*[contains(text(),'Warning')])/../../button
    Sleep   1s
    

    
Search Details Query id and set password in flexcube  
    [Arguments]   ${id}
    Sleep   3s
    Input text when element is visible  (//input[@id='fastpath'])[1]   SMSUSRDF
    Click element when visible  (//span[@class='ICOgo'])[1]
    Select frame  (//*[@class="frames"])[1]
    Sleep    2s
    Input text when element is visible  //input[@label_value="User Identification"]    %${id}
    Click element   //li[@id="Search"]/a
    Double click element   //table[@id="TBL_QryRslts"]/tbody/tr[1]/td[2]/a
    Unselect frame
    Sleep   4s
    Select frame  //iframe[contains (@title,'User Maintenance')]
    ${end_date_text}   Get Value   //label[contains(text(),'End Date')]/../input[2]
    Log  ${end_date_text}
    IF  "${end_date_text}" == "" 
        Click element when visible  //a[contains(text(),"Unlock")]
        Sleep    2s
        ${enabled_or_not}    Does page contain element   //b[contains(text(),'User Status')]/../div/label[1]/input[@label_value="Enabled"]
        IF   ${enabled_or_not} == True
            Click element when visible    //b[contains(text(),'User Status')]/../div/label[1]/input
        END
        ${random_pass}=   generate random password
        Log  ${random_pass}
        Sleep  2s
        Input text  //input[@type="PASSWORD"]  ${random_pass}  True  
        Sleep   1s
        Click element when visible   //li[@id="Save"]
        Sleep   3s
        ${if_modified_able_or not}    Does page contain element    //iframe[contains (@title,'Information Message')]
        IF  ${if_modified_able_or not} == False
            Log   not modified able please handle it 
            Set global variable   ${if_modified_able_or not}    False
            Wait until page contains element  //iframe[contains (@title,'Error Message')]
            Select frame   //iframe[contains (@title,'Error Message')]
            Click element when visible  //*[contains(@title,"Ok")]/..
            Unselect frame
            Sleep   2s
            Wait until page contains element   //iframe[contains (@title,'User Maintenance')]
            Select frame    //iframe[contains (@title,'User Maintenance')]
            Click element when visible   //input[@id="BTN_EXIT_IMG"]

            Sleep   2s
            Wait until page contains element   //iframe[contains (@title,'Confirmation Message')]
            Select frame   //iframe[contains (@title,'Confirmation Message')]
            Click element when visible  //*[contains(@title,"Ok")]/..
            Sleep   2s
            ${if_not_exist}  Does page contain element  //h1[contains(text(),'User Maintenance')]/../div/a[1]
            IF  ${if_not_exist} == True
                Select frame    //iframe[contains (@title,'User Maintenance')]
                Sleep   2s
                Click element when visible   //h1[contains(text(),'User Maintenance')]/../div/a[1]
            END
            Wait until page contains element    //iframe[contains (@title,'User Summary')]
            Select frame     //iframe[contains (@title,'User Summary')]
            Click element when visible   //input[@id="BTN_EXIT"]
            Click element when visible   //a[contains(text(),'Sign Off')]
            Sleep   1.5s
            Select frame   //iframe[@id="ifr_AlertWin"]
            Click element when visible  //*[contains(@title,"Ok")]
            Unselect frame
            Close window
            send email  Exception Email  Error Message Failed to Modify the record ${id}. Kindly check at your own.  
            
        ELSE
            Wait until page contains element  //iframe[contains (@title,'Information Message')]
            Select frame   //iframe[contains (@title,'Information Message')]
            Click element when visible  //*[contains(@title,"Ok")]/..
            Unselect frame
            Sleep   2s
            Wait until page contains element   //iframe[contains (@title,'User Maintenance')]
            Select frame    //iframe[contains (@title,'User Maintenance')]
            Click element when visible   //input[@id="BTN_EXIT_IMG"]
            # Sleep   2s
            # Wait until page contains element   //iframe[contains (@title,'Confirmation Message')]
            # Select frame   //iframe[contains (@title,'Confirmation Message')]
            # Click element when visible  //*[contains(@title,"Ok")]/..
            # Sleep   1.5s
            Wait until page contains element    //iframe[contains (@title,'User Summary')]
            Select frame     //iframe[contains (@title,'User Summary')]
            Click element when visible   //input[@id="BTN_EXIT"]
            Click element when visible   //a[contains(text(),'Sign Off')]
            Sleep   1.5s
            Select frame   //iframe[@id="ifr_AlertWin"]
            Click element when visible  //*[contains(@title,"Ok")]
            Unselect frame

            Close window
        END
    ELSE
        Log   Send Email
        send email  Exception Email  End Date is given on the CBS against this id ${id}. Kindly check at your own.    
        # send email  Exception Email  End Date is given on the CBS against this id ${id}. Kindly check at your own.   ${user_email}   ${ip_no}     ${port_no}    ${receiver}     ${cc_receiver} 
    END
    [Return]  ${random_pass}

    



    

Resolve Ticket
    [Arguments]   ${EMP_NAME}   ${EMP_ROLES}   ${TICKET_ID}    ${emp_id}     ${emp_comment}    ${START_TIME}
    Switch window    MAIN
    sleep  1s
    Reload page
    Sleep   4s
    ${check_element_after_refresh}  Does page contain element   //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]
    
    IF  ${check_element_after_refresh} == True
        Wait until page contains element  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button  20s
        Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button
        Sleep  8s
        Wait until element is visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button//following::ul[1]/li[3]/a  20s
        Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button//following::ul[1]/li[3]/a
        Wait until element is visible  //textarea[@id="comments"]  20s
        Input text when element is visible  //textarea[@id="comments"]   ${EMP_NAME} ${EMP_ROLES}
        Click element when visible  //button[contains(text(),'Change Status')]
        Switch window    NEW
        Sleep  2s
        Select frame  //iframe[@id='ifr_AlertWin']
        Click element when visible  //*[contains(@title,"Ok")]
        Unselect frame
        CIM_Change_Existing_Role.Authorize ticket from checker ID   ${emp_id}    ${EMP_NAME}   ${EMP_ROLES}    ${emp_comment}    ${TICKET_ID}    ${START_TIME}
    ELSE
        ${tickets}   Get Element Count    //table[contains(@class,"table")]/tbody/tr/td[3]/b
        FOR  ${i}  IN RANGE  1  ${tickets}+1
            ${id_in_CIM}   Get text  (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]/../../td[1]/b
            IF  '${id_in_CIM}' == '${TICKET_ID}'
                Wait until page contains element  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button  20s
                Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button
                Sleep  8s
                Wait until element is visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button//following::ul[1]/li[3]/a  20s
                Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button//following::ul[1]/li[3]/a
                Wait until element is visible  //textarea[@id="comments"]  20s
                Input text when element is visible  //textarea[@id="comments"]   ${EMP_NAME} ${EMP_ROLES}
                Click element when visible  //button[contains(text(),'Change Status')]
                Switch window    NEW
                Sleep  2s
                Select frame  //iframe[@id='ifr_AlertWin']
                Click element when visible  //*[contains(@title,"Ok")]
                Unselect frame
                CIM_Change_Existing_Role.Authorize ticket from checker ID    ${emp_id}    ${EMP_NAME}   ${EMP_ROLES}    ${emp_comment}    ${TICKET_ID}    ${START_TIME}
                Log  Ticket foudnd
            ELSE
                log  no ticket found while resolving the ticket
                ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
                Update trace file role    ${emp_id}    ${EMP_NAME}   ${EMP_ROLES}    ${emp_comment}    ${TICKET_ID}   Ticket is not in our scope   ${START_TIME}   ${END_TIME}    Change existing role
        
            END
        END
        Log   Ticket not found after reloading page 
        ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
        Update trace file role    ${emp_id}    ${EMP_NAME}   ${EMP_ROLES}    ${emp_comment}    ${TICKET_ID}   Ticket not found after reloading page   ${START_TIME}   ${END_TIME}    Change existing role
    END
    [Return]    ${check_element_after_refresh}

*** Keywords ***
Authorize ticket from checker ID
    [Arguments]    ${emp_id}    ${EMP_NAME}   ${EMP_ROLES}    ${emp_comment}    ${TICKET_ID}    ${START_TIME}
    # Open Available Browser   ${Flexcube_URL}    browser_selection=Chrome  maximized=True
    # Select frame  //*[@id="ifr_AlertWin"]
    # Click element when visible  //*[contains(@title,"Ok")]
    # Unselect frame
    Input text when element is visible  //input[contains(@id,"USERID")]    ${Checkerusername}
    Input text when element is visible   //input[contains(@id,"user_pwd")]    ${Checkerpassword}
    Click element when visible  //*[contains(@value,"Sign In")]
    ${User_Login}=  Check User Log In
    log  ${User_Login}
    IF  '${User_Login}' == 'True'
        log  Plaese Clear The User
        Click element when visible  //*[contains(@title,"Ok")]
        Cleared The LogedIn User  ${flexcube_username}  ${flexcube_password}  ${flexcube_username}
        Select frame  //*[@id="ifr_AlertWin"]
        Click element when visible  //*[contains(@title,"Ok")]
        Input text when element is visible  //input[contains(@id,"USERID")]   ${Checkerusername}
        Input text when element is visible   //input[contains(@id,"user_pwd")]    ${checkerpassword}
        Click element when visible  //*[contains(@value,"Sign In")]
        Wait until page contains element   //*[@id="ifr_AlertWin"] 
        Select frame  //*[@id="ifr_AlertWin"]  
    END
    log  continue the flow
    Click element when visible  //*[contains(@title,"Ok")]
    Unselect frame
    Input text when element is visible  (//input[@id='fastpath'])[1]   SMSUSRDF
    Click element when visible  (//span[@class='ICOgo'])[1]
    Wait until page contains element   //iframe[contains (@title,'User Summary')]
    Select frame   //iframe[contains (@title,'User Summary')]
    
    Click element when visible   //label[contains(text(),'Authorization Status')]/../select
    Click element when visible   //label[contains(text(),'Authorization Status')]/../select/option[2]
    Sleep   0.5s
    Click element when visible   //li[contains (@id,'Search')][1]  
    
    ${name}=    Convert To Uppercase   ${EMP_NAME}
    Sleep   2s
    ${record_available}=   Does page contain element   //iframe[contains(@title,'Information Message')]
    IF  ${record_available} == False
        ${checker_record}   Does page contain element   (//*[contains(text(),'Unauthorized')]/../../../..)[3]/tbody/tr//td[9]/a[contains(text(),'${emp_id}')]//..//..//td[11]/a[contains(text(),'${name}')]
        IF  ${checker_record} == False
            log  Update trace file role
            ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
            Update trace file role    ${emp_id}    ${EMP_NAME}   ${EMP_ROLES}    ${emp_comment}    ${TICKET_ID}   Ticket not found on CHCKER   ${START_TIME}   ${END_TIME}    Change existing role
            Click element when visible    //a[contains(@title,"Close")]
            Click element when visible   //a[contains(text(),'Sign Off')]
            Wait until page contains element    //iframe[@id="ifr_AlertWin"]
            Select frame   //iframe[@id="ifr_AlertWin"]
            Click element when visible  //*[contains(@title,"Ok")]
            # Open Workbook    ${trace_file_name}
            # Set Active Worksheet    Sheet
            # Set Worksheet Value   ${excel_len}    6     Business Exception Not Resolved, Ticket not found on CHCKER
            # Save workbook
        ELSE
            Sleep    2s
            Double click element    (//*[contains(text(),'Unauthorized')]/../../../..)[3]/tbody/tr//td[9]/a[contains(text(),'${emp_id}')]//..//..//td[11]/a[contains(text(),'${name}')]
            Unselect frame
            Wait until element is visible   //iframe[contains (@title,'User Maintenance')]  
            Select frame    //iframe[contains (@title,'User Maintenance')]
            sleep  1s
            Click element when visible   (//a[contains(text(),'Authorize')])
            sleep  2s
            Wait until page contains element    //iframe[contains(@title,'Authorize')]
            Select frame    //iframe[contains(@title,'Authorize')]
            Click element when visible   //input[contains(@Value,'Accept')]
            Wait until page contains element   //iframe[contains(@title,"Information Message")]
            select frame  //iframe[contains(@title,"Information Message")]
            Click element when visible  //*[contains(@title,"Ok")]
            Wait until page contains element    //iframe[contains (@title,'User Maintenance')]
            Select frame    //iframe[contains (@title,'User Maintenance')]
            Click element when visible   //input[@id="BTN_EXIT_IMG"]
            Wait Until Page Contains Element  //iframe[contains (@title,'User Summary')]  20
            Select frame     //iframe[contains (@title,'User Summary')]
            
            Click element when visible  //a[contains(text(),'Refresh')]
            Sleep   2s
            ${autho_available}   Does page contain element   (//table[@id="TBL_QryRslts"]/tbody/tr/td/a[contains(text(),'Unauthorized')])[1]
            IF  '${autho_available}' == 'True'
                ${unauthorizeds}   Get Element Count   //table[@id="TBL_QryRslts"]/tbody/tr/td/a[contains(text(),'Unauthorized')]                                  # Check if any authorize is in pending
                FOR  ${j}  IN RANGE  1  ${unauthorizeds}+1
                    Double click element   (//table[@id="TBL_QryRslts"]/tbody/tr/td/a[contains(text(),'Unauthorized')])[${j}]
                    # Sleep     2s
                    Unselect frame
                    Wait until element is visible   //iframe[contains (@title,'User Maintenance')]  
                    Select frame    //iframe[contains (@title,'User Maintenance')]
                    ${RPA_MKR}   Does page contain element   //input[contains(@value,'${MAKER_NAME}')]
                    IF  '${RPA_MKR}' == 'True'
                        sleep  1s
                        ${id_value_in_auth}  Get Value  //label[contains(text(),'User Reference')]/../input
                        Click element when visible   (//a[contains(text(),'Authorize')])
                        sleep  2s
                        Wait until page contains element    //iframe[contains(@title,'Authorize')]
                        Select frame    //iframe[contains(@title,'Authorize')]
                        Click element when visible   //input[contains(@Value,'Accept')]
                        Wait until page contains element   //iframe[contains(@title,"Information Message")]
                        select frame  //iframe[contains(@title,"Information Message")]
                        Click element when visible  //*[contains(@title,"Ok")]
                        Wait until page contains element    //iframe[contains (@title,'User Maintenance')]
                        Select frame    //iframe[contains (@title,'User Maintenance')]
                        Click element when visible   //input[@id="BTN_EXIT_IMG"]
                        Wait Until Page Contains Element  //iframe[contains (@title,'User Summary')]  20
                        Select frame     //iframe[contains (@title,'User Summary')]
                        Open Workbook    ${Reporting_File}
                        Set Active Worksheet    Sheet
                        ${table}   Read Worksheet As Table
                        ${excel_len}   Get length  ${table}
                        ${excel_len}   Evaluate   ${excel_len}+1
                        FOR  ${k}  IN RANGE  1  ${excel_len}+1
                            ${cell_value}   Get Worksheet Value    ${k}    1
                            IF  '${cell_value}' == '${id_value_in_auth}'
                                Set Worksheet Value   ${k}    6     Ticket Resolved Successfully
                                ${ID_value}   Get Worksheet Value   ${k}    5
                                Save Workbook 
                                send email  Exception Email  Now Bot has resolved ticket no ${ID_value} from Checker
                            END
                        END
                    ELSE
                        # Wait until page contains element    //iframe[contains (@title,'User Maintenance')]
                        # Select frame    //iframe[contains (@title,'User Maintenance')]
                        Click element when visible   //input[@id="BTN_EXIT_IMG"]
                        Log   No additional ticket are available for authorize
                        Wait Until Page Contains Element  //iframe[contains (@title,'User Summary')]  20
                        Select frame     //iframe[contains (@title,'User Summary')]
                    END
                END                                                                                                                                             
            END                                                                                                                                              # Check if any auth end here   
            
            Click element when visible   //input[@id="BTN_EXIT"]
            Click element when visible   //a[contains(text(),'Sign Off')]
            Wait until page contains element    //iframe[@id="ifr_AlertWin"]
            Select frame   //iframe[@id="ifr_AlertWin"]
            Click element when visible  //*[contains(@title,"Ok")]
        END
    ELSE
        # Open Workbook    ${trace_file_name}
        # Set Active Worksheet    Sheet
        # Set Worksheet Value   ${excel_len}    6     Business Exception Not Resolved, Ticket not found on CHCKER
        # Save workbook
        Log   No Record found in Checker
        ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
        Update trace file role    ${emp_id}    ${EMP_NAME}   ${EMP_ROLES}    ${emp_comment}    ${TICKET_ID}   No Record found in Checker   ${START_TIME}   ${END_TIME}    Change existing role
        
        Select frame   //iframe[contains(@title,'Information Message')]
        Click element when visible  //*[contains(@title,"Ok")]
    END
    Unselect frame
    Close window
    
    

# *** Tasks ***
# Change Existing Role Process Tasks
#     # Read Config File
    # # Authorize ticket from checker ID
    # ${checkpoint_status}    Run Keyword And Return Status    Trace File CheckPoint
    # IF    ${checkpoint_status}
    #     log    File exist        
    # ELSE
    #     log  file not exist create it
    #     Create Trace File
    # END 
    # Read Config File
    # Open the CIM URL   
    # ${login_status}  Check Login sucessfull or not for CIM
    # Log    ${login_status}
    # Get tickets from CIM identify ticket and work on FlexCube
