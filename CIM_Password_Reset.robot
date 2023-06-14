*** Keywords ***
Assign bot on cim and click view button
    [Arguments]   ${ticket_number}   ${Reporting_File}
    Set Global Variable     ${Reporting_File}    ${Reporting_File}
    Sleep   2s
    ${ID_in_CIM}=   Get text    ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[1]/b)[${ticket_number}]
    Click element when visible    ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[7]/select)[${ticket_number}]
    Click element when visible    ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[7]/select/option[contains(text(),'ammad.mm')])[${ticket_number}]
    Click element   ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[9]/a)[${ticket_number}]
    Sleep   9s
    # Run keyword and ignore error   Click element  //button[@class="close" and @onclick="reloadScreen()"]   
    [Return]    ${ID_in_CIM}

*** Keywords ***
Unassign the ticket 
    [Arguments]   ${ticket_number}
    Click element when visible    ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[7]/select)[${ticket_number}]
    Click element when visible    ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[7]/select/option[contains(text(),'Select Identity User')])[${ticket_number}]
    Sleep   2s 
    Run Keyword And Ignore Error   Click element when visible     (//*[contains(text(),'Warning')])/../../button
    Sleep   1s
    
*** Keywords ***
Get Ticket Texts From CIM
    [Arguments]   ${ticket_number}
    # Run Keyword And Ignore Error  Wait until page contains element     (//table)[2]     20s
    Sleep   1s
    ${handle_alert}   Run keyword and return status   Handle alert   ACCEPT
    Sleep    1s
    Run Keyword And Ignore Error  Wait Until Keyword Succeeds  2x  2s  Handle alert   ACCEPT
    ${emp_id}=   Get text   //div[@id="employeeId"]
    IF  '${emp_id}' == ''
        # Sleep     5s
        Run Keyword And Ignore Error  Wait Until Keyword Succeeds  3x  2s  Handle alert   ACCEPT
        ${emp_id}=   Get text   //div[@id="employeeId"]
        IF  '${emp_id}' == ''
            Click element   ((//b[contains(text(),'Change of Existing Role In FlexCube') or contains(text(),'New Flexcube User') or contains(text(),'Enable User ID In FlexCube') or contains(text(),'Reset Password Flex Cube')])/../../td[9]/a)[${ticket_number}]
        END
        # Sleep   5s
        # ${handle_alert}   Run keyword and return status   Handle alert   ACCEPT
        # IF  ${handle_alert} == True
        #     Sleep    4s
        # END
    # ELSE
    #     Log   In else
    END
    Sleep    6s
    # Run keyword and return status   Handle alert   ACCEPT
    # Sleep   4s
    # Run keyword and return status   Handle alert   ACCEPT
    # Run Keyword And Ignore Error  Wait Until Keyword Succeeds  3x  4s  Handle alert   ACCEPT
    # Run Keyword And Ignore Error  Wait Until Keyword Succeeds  3x  4s  Handle alert   ACCEPT
    # Wait until page contains element     //div[@id="employeeId"]      20s
    ${emp_id}   Get text   //div[@id="employeeId"] 
    ${emp_name}   Get text   //div[@id="employeeName"]
    ${emp_roles}   Get text   //div[@id="requestedRequests"]
    ${emp_comment}   Get text   //textarea[@id="userComments"]
    # Set global variable  ${EMP_NAME}  ${emp_name}
    # Set global variable  ${EMP_ROLES}  ${emp_roles}
    # Run keyword and return status   Handle Alert
    # Sleep   0.5s
    Run keyword and ignore error   Click element  //button[@class="close" and @onclick="reloadScreen()"]   
    sleep   1s
    Run keyword and ignore error   Click element   ((//table)[2]/../../../div/button)[1]
    [Return]   ${emp_id}  ${emp_name}  ${emp_roles}   ${emp_comment} 
    
*** Keywords ***
Comment Exception handelling
    [Arguments]    ${id_for_xpath_row}
     ${button_got}   Run keyword and return status   Click element    //*[contains(text(),'${id_for_xpath_row}')]/../../td[13]/div/ul/li[3]
	 IF  ${button_got} == False      
		Sleep   1s
		Reload Page
        Sleep    10s
		Click element when visible   //*[contains(text(),'${id_for_xpath_row}')]/../../td[13]/div/button
		sleep   1s
		Click element    //*[contains(text(),'${id_for_xpath_row}')]/../../td[13]/div/ul/li[3]
	 END

*** Keywords ***
Comment on cim after maker
    [Arguments]   ${id_for_xpath_row}    ${emp_name}     ${random_pass}
    switch window    MAIN
    Sleep   1s
    Reload Page
    Wait until page contains element   //h3[@class='box-title']   120s
    log  check ticket exist in CIM portal after Flexcube tasks complete ${id_for_xpath_row}
    ${ticket_number_exist}  Does Page Contain Element  //*[contains(text(),'${id_for_xpath_row}')]
         # //*[contains(text(),'257313')]
    # Click element when visible     //*[contains(text(),'${id_for_xpath_row}')]/../../td[13]
    IF  '${ticket_number_exist}'=='True'
        Click element when visible     //*[contains(text(),'${id_for_xpath_row}')]/../../td[13]/div/button
        sleep   1s
        Wait Until Keyword Succeeds  3x  3s  Comment Exception handelling   ${id_for_xpath_row}
        
        
        # Click element when visible   (//*[contains(text(),'Reset Password Flex Cube')]//following::td[10])[${ii}]/div/button
        # Click element when visible   (//*[contains(text(),'Reset Password Flex Cube')]//following::td[10])[${ii}]/div/ul/li[3]
        Input text when element is visible   //textarea[contains(@id,"comments")]    Employee ${emp_name} NewPassword ${random_pass}
        Click element when visible   //button[contains(text(),"Change Status")]
        Sleep   3s
    ELSE
        log  ${id_for_xpath_row} not found in the CIM portal while resolving the ticket
        
    END
     
# Get tickets from CIM And Change Password in FlexCube
#     ${Available_ticket_or_not}   Does page contain element    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[2][contains(text(),'CBS')])[1]
#     IF  ${Available_ticket_or_not} == True
#         ${tickets}   Get Element Count    //*[contains(text(),'Reset Password Flex Cube')]//following::td[2][contains(text(),'CBS')]
#         FOR  ${i}  IN RANGE  1  ${tickets}+1
#             @{WindowHandles}=   get window handles
#             switch window    ${WindowHandles}[0]
#             ${is_ticket_remaining}    Does page contain element     (//*[contains(text(),'Reset Password Flex Cube')]//following::td[4]/select)[${ii}]
#             IF  ${is_ticket_remaining} == False
#                 Exit for loop
#             END
#             ${id_for_xpath_row}=   Get text    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[2][contains(text(),'CBS')])[${ii}]/../td[1]/b
#             Click element when visible    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[4]/select)[${ii}]
#             Click element when visible    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[4]/select/option[contains(text(),'rpa.admin')])[${ii}]
#             Click element   (//*[contains(text(),'Reset Password Flex Cube')]//following::td[6])[${ii}]/a
#             # Run keyword and return status   Handle Alert   True
#             Sleep    5s
#             Run keyword and return status   Handle Alert   True
#             #Wait until page contains element     (//table)[2]     20s
#             Sleep   3s
#             # Run keyword and return status   Handle Alert   True  
#             Run keyword and return status   Handle Alert   True
#             ${emp}=   Get text   //*[@id="authorizeRequestModal"]/div/div/div/b
#             Log   ${emp}
#             ${emp_id}=   Get text   //div[@id="employeeId"]
#             IF  '${emp_id}' == ''
#                 Sleep   5s
#                 ${handle_alert}   Run keyword and return status   Handle alert   ACCEPT
#                 IF  ${handle_alert} == True
#                     Sleep    4s
#                 END
#             END
#             # Sleep    6s
#             ${table_is visiable}    Get text   //div[@id="employeeId"]
#             IF  '${table_is visiable}' == ''
#                 Run keyword and return status   Handle alert   ACCEPT
#                 Sleep   4s
#                 Run keyword and return status   Handle alert   ACCEPT
#             END
#             # Click element when visible  //*[contains(text(),'Approve/Reject Request')]
#             # Click element   (//*[contains(text(),'Reset Password Flex Cube')]//following::td[6])[${ii}]/a
#             Wait until page contains element     (//table)[2]     20s
#             ${emp_id}   Get text   //div[@id="employeeId"] 
#             ${emp_name}   Get text   //div[@id="employeeName"]
#             ${emp_roles}   Get text   //div[@id="requestedRequests"]
#             ${emp_comment}   Get text   //textarea[@id="userComments"]
#             ${created_by}  Get text    //div[@id="createdBy"]
#             Log   ${emp_id}
#             ${START_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
#             # Run keyword and return status   Handle Alert
#             Run keyword and ignore error   Click element when visible   //button[@class="close" and @onclick="reloadScreen()"]
#             Click element when visible   ((//table)[2]/../../../div/button)[1]
#             IF  'LOV' in '${emp_comment}' or 'lov' in '${emp_comment}'
# 				Click element when visible    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[4]/select)[${ii}]
# 				Click element when visible    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[4]/select/option[contains(text(),'Select Identity User')])[${ii}]
# 				Sleep   2s
# 				Click element when visible     (//*[contains(text(),'Warning')])/../../button
# 				${ii}   Evaluate    ${ii}+1
#                 Continue for loop
#             END
#             Open The Flexcube URL                                  # Flexcube process Starts from here
#             Login to Flexcube
#             ${random_pass}   Search Details Query id and set password in flexcube       ${emp_id}
#             IF  ${if_modified_able_or not} == False
#                 Log   User is already loged in and Email is sent for testing on it own
#                 Continue for loop
#             END
#             Open Workbook    ${trace_file_name}
#             Set Active Worksheet    Sheet
#             ${table}   Read Worksheet As Table
#             ${excel_len}   Get length  ${table}
#             ${excel_len}   Evaluate   ${excel_len}+1
#             Set Worksheet Value   ${excel_len}    1     ${emp_id}
#             Set Worksheet Value   ${excel_len}    2     ${emp_name}
#             Set Worksheet Value   ${excel_len}    3     ${emp_roles}
#             Set Worksheet Value   ${excel_len}    4     ${emp_comment}
#             Set Worksheet Value   ${excel_len}    5     ${id_for_xpath_row} 
#             Set Worksheet Value   ${excel_len}    7     ${START_TIME}
#             Save Workbook
#             @{WindowHandles}=   get window handles
#             switch window    ${WindowHandles}[0]
#             Sleep   1s
#             Reload Page
            
#             Wait until page contains element   //h3[@class='box-title']  120s
#             log  check ticket exist in CIM portal after Flexcube tasks complete ${id_for_xpath_row}
#             ${ticket_number_exist}  Does Page Contain Element  //*[contains(text(),'${id_for_xpath_row}')]
#                  # //*[contains(text(),'257313')]
#             # Click element when visible     //*[contains(text(),'${id_for_xpath_row}')]/../../td[13]
#             IF  '${ticket_number_exist}'=='True'
#                 Click element when visible     //*[contains(text(),'${id_for_xpath_row}')]/../../td[13]/div/button
#                 sleep   1s
#                 Wait Until Keyword Succeeds  3x  3s  Comment Exception handelling   ${id_for_xpath_row}
                
#                 # Click element when visible   (//*[contains(text(),'Reset Password Flex Cube')]//following::td[10])[${ii}]/div/button
#                 # Click element when visible   (//*[contains(text(),'Reset Password Flex Cube')]//following::td[10])[${ii}]/div/ul/li[3]
#                 Input text when element is visible   //textarea[contains(@id,"comments")]    Employee ${emp_name} NewPassword ${random_pass}
#                 Click element when visible   //button[contains(text(),"Change Status")]
#                 Sleep   3s
#                 ${Ticket_status}=  Run keyword and return status  Open The Flexcube for checker authorization    ${ii}   ${emp_id}  ${emp_name}   ${created_by}    ${excel_len}            # Checker process
#                 IF  '${Ticket_status}' == 'False'
#                     Set Worksheet Value   ${excel_len}    6     Ticket Not Resolved on checker
# 		    ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
#                     Set Worksheet Value   ${excel_len}    8     ${END_TIME}
#                     Save Workbook
#                     switch window  MAIN
#                     Click element when visible    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[4]/select)[${ii}]
#                     Click element when visible    (//*[contains(text(),'Reset Password Flex Cube')]//following::td[4]/select/option[contains(text(),'Select Identity User')])[${ii}]
#                     Sleep   2s
#                     Click element when visible     (//*[contains(text(),'Warning')])/../../button
#                     ${ii}   Evaluate    ${ii}+1
#                 ELSE
#                     Set Worksheet Value   ${excel_len}    6     Ticket Resolved Sucessfully
#                     ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
#                     Set Worksheet Value   ${excel_len}    8     ${END_TIME}
#                     Save Workbook
#                 END
#             ELSE
#                 log  ${id_for_xpath_row} not found in the CIM portal while resolving the ticket
#                 Set Worksheet Value   ${excel_len}    6     Business Exception Not Resolved, ${id_for_xpath_row} ticket not found on CIM portal
#                 Save Workbook
#             END
#         END
#         Close Workbook
#     ELSE
#         Log  No Ticket availabale
#     END
#     Close browser

*** Keywords ***
Open The Flexcube for checker authorization         
    [Arguments]    ${emp_id}   ${name}     ${id}   ${emp_roles}   ${emp_comment}    ${START_TIME} 
    Execute Javascript    window.open('${Flexcube_URL}')
    # Set Log Level    None
    @{WindowHandles}=   get window handles
    switch window  NEW
    Wait until page contains element    //*[@id="ifr_AlertWin"]
    Select frame  //*[@id="ifr_AlertWin"]
    Click element when visible  //*[contains(@title,"Ok")]
    Unselect frame
    Input text when element is visible  //input[contains(@id,"USERID")]  ${Checkerusername}
    Input text when element is visible   //input[contains(@id,"user_pwd")]    ${checkerpassword}
    Click element when visible  //*[contains(@value,"Sign In")]
    sleep  1s
    ${User_Login}=  Check User Log In
    log  ${User_Login}
    IF  '${User_Login}' == 'True'
        log  Plaese Clear The User
        Click element when visible  //*[contains(@title,"Ok")]
        Cleared The LogedIn User  ${flexcube_username}  ${flexcube_password}  ${Checkerusername}
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
    
    # Input text when element is visible    //label[contains(text(),'User Identification')]/../input   ${emp_id}
    # Click element when visible   //label[contains(text(),'User Identification')]/../button
    
    Click element when visible   //label[contains(text(),'Authorization Status')]/../select
    Click element when visible   //label[contains(text(),'Authorization Status')]/../select/option[2]
    Sleep   0.5s
    Click element when visible   //li[contains (@id,'Search')][1]  
    ${name}=    Convert To Uppercase   ${name}
    Sleep   2s
    ${record_available}   Does page contain element   //iframe[contains(@title,'Information Message')]
    IF  ${record_available} == False
        Sleep   2s
        ${checker_record}   Does Page Contain Element   (//*[contains(text(),'Unauthorized')]/../../../..)[3]/tbody/tr//td[9]/a[contains(text(),'${emp_id}')]//..//..//td[11]/a[contains(text(),'${name}')]
        IF  ${checker_record} == False
            # Open Workbook    ${trace_file_name}
            # Set Active Worksheet    Sheet
            ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
            Update trace file password    ${emp_id}    ${name}   ${emp_roles}    ${emp_comment}    ${id}   Ticket not found on check so authorization is on pending   ${START_TIME}   ${END_TIME}    Reset Password Flex Cube
            send email  Exception Email   Ticket not found on CHCKER ${id}. Kindly check at your own.
            Log     Business Exception Not Resolved, Ticket not found on CHCKER
            Click element when visible    //a[contains(@title,"Close")]
            Click element when visible   //a[contains(text(),'Sign Off')]
            Wait until page contains element    //iframe[@id="ifr_AlertWin"]
            Select frame   //iframe[@id="ifr_AlertWin"]
            Click element when visible  //*[contains(@title,"Ok")]
            # Save workbook
        ELSE
            Double click element    (//*[contains(text(),'Unauthorized')]/../../../..)[3]/tbody/tr//td[9]/a[contains(text(),'${emp_id}')]//..//..//td[11]/a[contains(text(),'${name}')]
            Sleep    2s
            # Double click element    //table[@id="TBL_QryRslts"]/tbody/tr//td[9]/a[contains(text(),'${emp_id}')]//..//..//td[11]/a[contains(text(),'${name}')]
            # Double click element    (//a[contains(text(),'Unauthorized')])[${counter}]/../../td[11]/a[contains(text(),'${name}')]
            Unselect frame
            # Sleep   1.5s
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
                            ${cell_value}   Get Worksheet Value    ${k}   1
                            IF  '${cell_value}' == '${id_value_in_auth}'
                                Set Worksheet Value   ${k}    6     Ticket Resolved Successfully
                                ${ID_value}   Get Worksheet Value    ${k}  5
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
            END                                                                                                                                             # Check if any auth end here 
            
            Click element when visible   //input[@id="BTN_EXIT"]
            Click element when visible   //a[contains(text(),'Sign Off')]
            Wait until page contains element    //iframe[@id="ifr_AlertWin"]
            Select frame   //iframe[@id="ifr_AlertWin"]
            Click element when visible  //*[contains(@title,"Ok")]
        END
    ELSE
        # Open Workbook    ${trace_file_name}
        # Set Active Worksheet    Sheet
        ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
        Update trace file password    ${emp_id}    ${name}   ${emp_roles}    ${emp_comment}    ${id}   Business Exception Not Resolved, Ticket not found on CHCKER  ${START_TIME}   ${END_TIME}    Reset Password Flex Cube    
        Log     Business Exception Not Resolved, Ticket not found on CHCKER
        # Save workbook
        Log   No Record found in Checker
        Select frame   //iframe[contains(@title,'Information Message')]
        Click element when visible  //*[contains(@title,"Ok")]
    END
    Unselect frame
    Close window
    
*** Keywords ***
Update trace file password
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


Search Details Query id and set password in flexcube  
    [Arguments]   ${id}   ${ticket_number}   ${emp_id}  ${emp_name}  ${emp_roles}   ${emp_comment}  ${START_TIME} 
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
            ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
            Update trace file password    ${emp_id}    ${emp_name}   ${emp_roles}    ${emp_comment}    ${id}   Ticket not Resolved not modifiedable   ${START_TIME}   ${END_TIME}    Reset Password Flex Cube
            send email  Exception Email  Error Message Failed to Modify the record ${id}. Kindly check at your own.    # ${user_email}   ${ip_no}     ${port_no}    ${receiver}     ${cc_receiver} 
            
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
        Unassign the ticket   ${ticket_number}
        ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
        Update trace file password    ${emp_id}    ${emp_name}   ${emp_roles}    ${emp_comment}    ${id}   End date is given so we do not resolve this ticket   ${START_TIME}   ${END_TIME}    Reset Password Flex Cube
        Log   Send Email
        send email  Exception Email  End Date is given on the CBS against this id ${id}. Kindly check at your own.     # ${user_email}   ${ip_no}     ${port_no}    ${receiver}     ${cc_receiver} 
        # send email  Exception Email  End Date is given on the CBS against this id ${id}. Kindly check at your own.   ${user_email}   ${ip_no}     ${port_no}    ${receiver}     ${cc_receiver} 
    END
    [Return]  ${random_pass}









