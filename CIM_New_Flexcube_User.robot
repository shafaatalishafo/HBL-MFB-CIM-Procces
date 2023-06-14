*** Keywords ***
   
Get ticket texts from cim for new user creation
    [Arguments]   ${Reporting_File}   ${i}   ${START_TIME}   ${ID_in_CIM}
    Set global variable   ${trace_file_name}     ${Reporting_File}
    Set global variable   ${START_TIME}     ${START_TIME}
    Set global variable   ${id}     ${ID_in_CIM}
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
    Set global variable  ${EMPLOYEE_ID}  ${emp_id}
    ${Ticket_ID}   Get text  (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]/../../td[1]/b
    Set global variable  ${TICKET_ID}  ${Ticket_ID}
    ${split_name}  Split String  ${emp_name}  ${SPACE}
    ${Check_length}  Get length  ${split_name}
    IF  ${Check_length} > 1
        ${first_name}  Set variable  ${split_name[0]}
        ${last_name}  Set variable  ${split_name[1]}
        Set global variable  ${FIRST_NAME}  ${first_name}
        Set global variable  ${LAST_NAME}  ${last_name}
    ELSE
        ${first_name}  Set variable  ${split_name[-1]}
        Set global variable  ${FIRST_NAME}  ${first_name}
    END
    Set global variable  ${EMP_NAME}  ${emp_name}
    Set global variable  ${EMP_ROLES}  ${emp_roles}
    # Run keyword and return status   Handle Alert
    ${caps_name} =	Convert To Uppercase	${emp_name}
    Set global variable  ${CAPS_NAME}  ${caps_name}
    ${cell_number}  Get text  //div[@id="contactNumber"]
    ${display_name}  Get text  //div[@id="displayName"]
    ${home_branch}  Get text  //div[@id="homeBranch"]
    Set global variable  ${HOME_BRANCH}  ${home_branch}
    ${dob}  Get text  //div[@id="dob"]
    ${department}  Get text  //div[@id="department"]
    ${designation}  Get text  //div[@id="designation"]
    Set global variable  ${designation}  ${designation}
    # ${designation_caps}    Evaluate    ''.join([word[0].upper() for word in '${designation}'.split()])
    # Set global variable  ${DESIGNATION_CAPS}  ${designation_caps}
    ${joining_date}  Get text  //div[@id="joiningdate"]
    Set global variable  ${EMP_ROLES}  ${emp_roles}
    ${emp_comment}   Get text   //textarea[@id="userComments"]
    Set global variable  ${emp_comment}  ${emp_comment}
    ${iniated_by}  Get text  //div[@id="createdBy"]
    ${iniated_by}  Get Regexp Matches    ${iniated_by}  \\d+
    ${integers}=    Create List
    FOR    ${match}    IN    @{iniated_by}
        Append To List    ${integers}    ${match}
    END
    ${iniated_by}=    Evaluate    ${integers}[0]
    Set global variable  ${iniated_by}  ${iniated_by}
    # ${iniated_by}    Get Substring    ${iniated_by}    -4
    Log   ${emp_id}
    # Run keyword and return status   Handle Alert
    Sleep   0.5s
    ${joining_date}  Get text  //div[@id="joiningdate"]
    ${emp_roles}   Get text   //div[@id="requestedRequests"]
    # Set global variable  ${EMP_ROLES}  ${emp_roles}
    # ${emp_comment}   Get text   //textarea[@id="userComments"]
    # Set global variable  ${emp_comment}  ${emp_comment}
    # ${iniated_by}  Get text  //div[@id="createdBy"]
    # ${iniated_by}    Get Substring    ${iniated_by}    -4
    # Set global variable  ${iniated_by}  ${iniated_by}
    # Run keyword and return status   Handle Alert
    sleep    1s
    Run keyword and ignore error   Click element  //button[@class="close" and @onclick="reloadScreen()"] 
    Sleep   0.5s
    Run keyword and ignore error   Click element when visible   ((//table)[2]/../../../div/button)[1]
    [Return]   ${designation}
    


Check Designation From Ticket
    [Arguments]  ${designation}
    IF  "${designation}" =="Teller"
         Set global variable  ${designation_caps}  ${designation}
    ELSE IF  "${designation}" =="Branch Manager" or "${designation}" =="PB Manager"
           Set global variable  ${designation_caps}  BM
    ELSE IF  "${designation}" =="Loan Officer" or "${designation}" =="MFO"
            Set global variable  ${designation_caps}  LO
    ELSE IF  "${designation}" =="Loan Officer" or "${designation}" =="MFO"
            Set global variable  ${designation_caps} LO
    ELSE IF  "${designation}" =="Branch Banking Officer" or "${designation}" =="Branch Banking OFFICER"
            Set global variable  ${designation_caps}  BBO
    ELSE IF  "${designation}" =="Branch Operations Manager" or "${designation}" =="Branch Operations Manager 2"
            Set global variable  ${designation_caps}  BOM
    Set global variable  ${DESIGNATION_CAPS}  ${designation_caps}
    
    ELSE
        Create Trace File Of Designation not matched with the Mapping sheet
    END

Fetch Branch Code From Excel
    Set global variable  ${BRANCH_CODE_EXIST}  False
    Open Workbook    ${EXCEL_FILE}   
    Set Active Worksheet    Branch Codes
    ${max_row}  Find empty row  Branch Codes
    FOR  ${i}  IN RANGE  2  ${max_row}
        ${Branch_name}  Get cell value  ${i}  1
        IF  '${HOME_BRANCH}' in '${Branch_name}'
            Set global variable  ${BRANCH_CODE_EXIST}  True
            ${Branch_Code}  Get cell value  ${i}  2
            Set global variable  ${BRANCH_CODE}  ${Branch_Code}
            Exit for loop
            Log  ${BRANCH_CODE}
        END
    END
    Save Workbook
    Close workbook
    [Return]   ${BRANCH_CODE_EXIST}




Search Details Query id In Flexcube
    Input text when element is visible  (//input[@id='fastpath'])[1]   SMSUSRDF
    Click element when visible  (//span[@class='ICOgo'])[1]
    Select frame  (//*[@class="frames"])[1]
    Sleep    2s
    Input text when element is visible  //input[@label_value="User Identification"]    %${iniated_by}
    Click element   //li[@id="Search"]/a
    Double click element   //table[@id="TBL_QryRslts"]/tbody/tr[1]/td[2]/a
    Unselect frame
    Sleep   4s
    Set global variable  ${Record_Exist_Flexcube}  False
    ${Record_Found}  Does page contain element  //iframe[contains (@title,'User Maintenance')]
    IF  '${Record_Found}' == 'True'
        Set global variable  ${Record_Exist_Flexcube}  True
        Select frame  //iframe[contains (@title,'User Maintenance')]
        Wait until page contains element  //a[contains(text(),'New')]  30s
        Click element when visible  //a[contains(text(),'New')]
        Select frame  //iframe[contains (@title,'User Maintenance')]
        Wait until page contains element  //a[contains(text(),'New')]  30s
        Click element when visible  //a[contains(text(),'New')]
    ELSE
        
        # Select frame  //iframe[@title="Information Message"]
        # Click element   //iframe[@title="Information Message"]
        sleep  2s
        Select frame  (//*[@class="frames"])[1]
        Select frame  //iframe[@title="Information Message"]
        Click element  //*[contains(@title,"Ok")]
        Unselect Frame
        Select frame  (//*[@class="frames"])[1]
        Click element when visible    //a[contains(@title,"Close")]
        Unselect Frame
        # Press Keys  None  ALT+7 
        Click element when visible   //a[contains(text(),'Sign Off')]
        Wait until page contains element    //iframe[@id="ifr_AlertWin"]
        Sleep  2s
        Select frame   //iframe[@id="ifr_AlertWin"]
        Click element when visible  //*[contains(@title,"Ok")]
        Press Keys  None  ENTER
        Sleep  2s
        Close window
    END
    # Fill Form In Flexcube
    # Select Checkboxes in Form For Designation
    # Sleep  8s
    # Save and Logout

Get Today Date
    ${current_date} =  Get Current Date  result_format=%Y-%m-%d
    Set global variable  ${CURRENT_DATE}  ${current_date}
    
    
Fill Form In Flexcube
    ${random_pass}=   generate random password
    Set global variable  ${RANDOM_PASS}  ${random_pass}
    ${concat_name_id}    Catenate    ${FIRST_NAME}    ${EMPLOYEE_ID}
    ${input_string}    Replace String    ${concat_name_id}    ${SPACE}  ${EMPTY}
    ${length_name_id}    Get length    ${input_string}
    IF  ${length_name_id} <= 13
        Input text  //input[@title="User Identification" and @type='text']  ${FIRST_NAME}${EMPLOYEE_ID}
    ELSE
         Input text  //input[@title="User Identification" and @type='text']  ${LAST_NAME}${EMPLOYEE_ID}
    END
    Input Text  //input[@title="Home Branch" and @type = 'text']  ${BRANCH_CODE}
    Input text  //input[@title="User Reference"]  ${EMPLOYEE_ID}
    Input text  //input[@name="USRNAME" and @type='text']  ${CAPS_NAME} ${DESIGNATION_CAPS}
    Click element when visible  //input[@title="User Status" and @label_value="Enabled"]
    Input text  //input[@title="Time Level"]  9
    Get Today Date
    Input text  //input[@title="Start Date"]  ${CURRENT_DATE}
    Input text  //input[@label_value="Password"]  ${RANDOM_PASS}
    IF  "${BRANCH_CODE}" == "001"
        Click element when visible  //b[contains(text(),'Classification')]/..//div/label/input
    ELSE
        Click element when visible  //b[contains(text(),'Classification')]/..//div/label[2]/input
    END
    Wait until page contains element  //a[contains(text(),'Branches')]  20s
    Click element when visible  //a[contains(text(),'Branches')]
    Sleep  2s
    Select frame  //iframe[contains(@title,'Branches')]
    # Click element when visible  //input[@label_value="Allowed"]
    Click element when visible  //input[@label_value="Disallowed"]
    Click element when visible  //input[@name="BTN_OK"]
    Select frame  //iframe[contains (@title,'User Maintenance')]


Select Checkboxes in Form For Designation
    IF  """BM""" in """${EMP_ROLES}""" or """PM""" in """${EMP_ROLES}"""
        Select checkbox  //input[@label_value="Show Dashboards"]
        Select Checkboxes From Front-end Upto MFI User
        Assign Roles BM
        Assign Tills BM
        Assign Limits BM
    ELSE IF  """BOM""" in """${EMP_ROLES}"""
        Select checkbox  //input[@label_value="Show Dashboards"]
        Select Checkboxes From Front-end Upto MFI User
        Assign Roles BOM
        Assign Tills BOM
        Assign Limits BOM
    ELSE IF  """MFO-TL""" in """${EMP_ROLES}"""
        Select checkbox  //input[@name="FRONTEND_DEBUG_ENABLED"]
        Select checkbox  //input[@label_value="F10 Access Required"]
        Select checkbox  //input[@name="MFI_USER"]
        Assign Roles MFO-TL
        Assign Limits MFO-TL
    ELSE IF  """MFO""" in """${EMP_ROLES}""" or """LO""" in """${EMP_ROLES}"""
        Select checkbox  //input[@name="FRONTEND_DEBUG_ENABLED"]
        Select checkbox  //input[@label_value="F10 Access Required"]
        Select checkbox  //input[@name="MFI_USER"]
        Select checkbox  //input[@label_value="Auto Authorization"]
        Assign Roles MFO
    ELSE IF  """TELLER""" in """${EMP_ROLES}"""
        Select Checkboxes From Front-end Upto MFI User
        Assign Role Teller
        Assign Tills Teller
        Assign Limits Teller
    ELSE IF  """BBO""" in """${EMP_ROLES}"""
        Select Checkboxes From Front-end Upto MFI User
        Assign Role BBO
        Assign Limits BBO
    ELSE
        Log  No Designation found.
        ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
         Open Workbook    ${trace_file_name}
         Set Active Worksheet    Sheet
         ${table}   Read Worksheet As Table
         ${excel_len}   Get length  ${table}
         ${excel_len}   Evaluate   ${excel_len}+1
         Set Worksheet Value   ${excel_len}    1     ${EMPLOYEE_ID}
         Set Worksheet Value   ${excel_len}    2     ${emp_name}
         Set Worksheet Value   ${excel_len}    3     ${EMP_ROLES}
         Set Worksheet Value   ${excel_len}    4     ${emp_comment}
         Set Worksheet Value   ${excel_len}    5     ${TICKET_ID}
         Set Worksheet Value   ${excel_len}    6     Ticket Not Resolved. ${home_branch} Branch Name and Code not found in the Mapping Sheet.
         Set Worksheet Value   ${excel_len}    7     ${START_TIME}
         Set Worksheet Value   ${excel_len}    8     ${END_TIME}
         Set Worksheet Value   ${excel_len}    9     New Flexcube User
         Set Worksheet Value   ${excel_len}    10    CBS
         Save Workbook
    END
    
Select Checkboxes From Front-end Upto MFI User
    Select checkbox  //input[@name="FRONTEND_DEBUG_ENABLED"]
    Select checkbox  //input[@label_value="F10 Access Required"]
    Select checkbox  //input[@label_value="F11 Access Required"]
    Select checkbox  //input[@label_value="F12 Access Required"]
    Select checkbox  //input[@name="MFI_USER"]   
    

Assign Roles BM
    Click element when visible  //a[contains(text(),'Roles')]
    Wait until page contains element  //iframe[contains (@title,'Roles')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  //input[@label_value="Branch Code"]  ${BRANCH_CODE}
    Input text when element is visible  //input[@title="Role"]  FMFB_BM
    Click element when visible  //input[@name="BTN_OK"]
    Wait until page contains element    //iframe[contains(@title,'List of Values Role')]
    Sleep  2s
    Select frame   //iframe[contains(@title,'List of Values Role')]
    Wait until page contains element  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_BM']  20s
    Click element when visible  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_BM']
    Unselect frame
    Sleep  2s
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  (//input[@label_value="Branch Code"])[2]  ${BRANCH_CODE}
    Input text when element is visible  (//input[@title="Role"])[2]  officer
    Click element when visible  //input[@name="BTN_OK"]
    
Assign Tills BM
    Sleep  2s
    Select frame    (//iframe[contains(@title,'User Maintenance')])
    Wait until page contains element  //a[contains(text(),'Tills')]  20s
    Click element when visible  //a[contains(text(),'Tills')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Tills')]
    Click element when visible  //input[@label_value="Allowed"]
    Wait until page contains element  //button[@title="Add Row"]  10s
    Click element when visible  //button[@title="Add Row"]
    Click element when visible  //input[@title="Till Id"]/../button
    Sleep  2s
    Select frame   //iframe[contains(@title,'List of Values Till Id')]
    Input text  (//label[contains(text(),' Branch')]//following::input[@type="TEXT" and @value="%"])[1]  %${BRANCH_CODE}
    Click element when visible  //button[contains(text(),'Fetch Values')]
    Click element when visible  //a[contains(text(),'VAULT')]
    Unselect frame
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Select frame  //iframe[contains (@title,'Tills')]
    Click element when visible  //input[@name="BTN_OK"]
    
Assign Limits BM
    Select frame    (//iframe[contains(@title,'User Maintenance')])
    Wait until page contains element  //a[contains(text(),'Limits')]  20s
    Click element when visible  //a[contains(text(),'Limits')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Limits')]
    Click element when visible  //input[@label_value="User Limits"]
    Input text when element is visible  //input[@label_value="Limit Currency"]  PKR
    Input text when element is visible  //input[@title="Maximum Transaction Amount"]  0
    Input text when element is visible  //input[@title="Authorization Limit"]  999999999
    Click element when visible  //input[contains(@value,"Ok")]
    Sleep  2s
    Select frame    (//iframe[contains(@title,'User Maintenance')])  
    Click element when visible  //a[contains(text(),"Save")] 

Assign Roles BOM
    Click element when visible  //a[contains(text(),'Roles')]
    Wait until page contains element  //iframe[contains (@title,'Roles')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  //input[@label_value="Branch Code"]  ${BRANCH_CODE}
    Input text when element is visible  //input[@title="Role"]  FMFB_BOI
    Click element when visible  //input[@name="BTN_OK"]
    Wait until page contains element    //iframe[contains(@title,'List of Values Role')]
    Select frame   //iframe[contains(@title,'List of Values Role')]
    Wait until page contains element  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_BOI']  20s
    Click element when visible  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_BOI']
    Unselect frame
    Sleep  2s
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  (//input[@label_value="Branch Code"])[2]  ${BRANCH_CODE}
    Input text when element is visible  (//input[@title="Role"])[2]  officer
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  (//input[@label_value="Branch Code"])[3]  ${BRANCH_CODE}
    Input text when element is visible  (//input[@title="Role"])[3]  Fmfbtabuser
    Click element when visible  //input[@name="BTN_OK"]

Assign Tills BOM
    Assign Tills BM
    
Assign Limits BOM
    Sleep  2s
    Select frame    (//iframe[contains(@title,'User Maintenance')])
    Wait until page contains element  //a[contains(text(),'Limits')]  20s
    Click element when visible  //a[contains(text(),'Limits')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Limits')]
    Click element when visible  //input[@label_value="User Limits"]
    Input text when element is visible  //input[@label_value="Limit Currency"]  PKR
    Input text when element is visible  //input[@title="Maximum Transaction Amount"]  999999999
    Input text when element is visible  //input[@title="Authorization Limit"]  400,00
    Click element when visible  //input[contains(@value,"Ok")]
    Select frame    (//iframe[contains(@title,'User Maintenance')])  
    Click element when visible  //a[contains(text(),"Save")] 

Assign Roles MFO-TL
    Click element when visible  //a[contains(text(),'Roles')]
    Wait until page contains element  //iframe[contains (@title,'Roles')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  //input[@label_value="Branch Code"]  ${BRANCH_CODE}
    Input text when element is visible  //input[@title="Role"]  FMFB_MFO_TL
    Click element when visible  //input[@name="BTN_OK"]
    
    
Assign Limits MFO-TL
    Sleep  2s
    Select frame    (//iframe[contains(@title,'User Maintenance')])
    Wait until page contains element  //a[contains(text(),'Limits')]  20s
    Click element when visible  //a[contains(text(),'Limits')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Limits')]
    Click element when visible  //input[@label_value="User Limits"]
    Click element when visible  //input[contains(@value,"Ok")]
    Select frame    (//iframe[contains(@title,'User Maintenance')])  
    Click element when visible  //a[contains(text(),"Save")] 
   
Assign Roles MFO
    Sleep  2s
    Click element when visible  //a[contains(text(),'Roles')]
    Sleep  2s
    Wait until page contains element  //iframe[contains (@title,'Roles')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  //input[@label_value="Branch Code"]  ${BRANCH_CODE}
    Input text when element is visible  //input[@title="Role"]  FMFB_MFO
    Click element when visible  //input[@name="BTN_OK"]
    Sleep   2s
    Wait until page contains element    //iframe[contains(@title,'List of Values Role')]
    Select frame   //iframe[contains(@title,'List of Values Role')]
    Wait until page contains element  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_MFO']  20s
    Click element when visible  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_MFO']
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible  //input[@name="BTN_OK"]
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Click element when visible  //a[contains(text(),"Save")] 
    
Assign Role Teller
    Sleep  2s
    Click element when visible  //a[contains(text(),'Roles')]
    Sleep  2s
    Wait until page contains element  //iframe[contains (@title,'Roles')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  //input[@label_value="Branch Code"]  ${BRANCH_CODE}
    Input text when element is visible  //input[@title="Role"]  FMFB_TELLER
    Click element when visible  //input[@name="BTN_OK"]
    Sleep   2s
    Wait until page contains element    //iframe[contains(@title,'List of Values Role')]
    Select frame   //iframe[contains(@title,'List of Values Role')]
    Wait until page contains element  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_TELLER']  20s
    Click element when visible  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_TELLER']
    Unselect frame
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible  //input[@name="BTN_OK"]
    
    
Assign Tills Teller
    Select frame    (//iframe[contains(@title,'User Maintenance')])
    Wait until page contains element  //a[contains(text(),'Tills')]  20s
    Click element when visible  //a[contains(text(),'Tills')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Tills')]
    Click element when visible  //input[@label_value="Allowed"]
    Wait until page contains element  //button[@title="Add Row"]  10s
    Click element when visible  //button[@title="Add Row"]
    Click element when visible  //input[@title="Till Id"]/../button
    Sleep  2s
    Select frame   //iframe[contains(@title,'List of Values Till Id')]
    Input text  (//label[contains(text(),' Branch')]//following::input[@type="TEXT" and @value="%"])[1]  %${BRANCH_CODE}
    Click element when visible  //button[contains(text(),'Fetch Values')]
    Click element when visible  //a[contains(text(),'TILL_1')]
    Unselect frame
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Select frame  //iframe[contains (@title,'Tills')]
    Click element when visible  //input[@name="BTN_OK"]
    
Assign Limits Teller
    Select frame    (//iframe[contains(@title,'User Maintenance')])
    Wait until page contains element  //a[contains(text(),'Limits')]  20s
    Click element when visible  //a[contains(text(),'Limits')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Limits')]
    Click element when visible  //input[@label_value="User Limits"]
    Input text when element is visible  //input[@label_value="Limit Currency"]  PKR
    Input text when element is visible  //input[@title="Maximum Transaction Amount"]  999999999
    Input text when element is visible  //input[@title="Authorization Limit"]  0
    Click element when visible  //input[contains(@value,"Ok")]
    Select frame    (//iframe[contains(@title,'User Maintenance')])  
    Click element when visible  //a[contains(text(),"Save")]    
    
Assign Role BBO
    Sleep  2s
    Click element when visible  //a[contains(text(),'Roles')]
    Sleep  2s
    Wait until page contains element  //iframe[contains (@title,'Roles')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  //input[@label_value="Branch Code"]  ${BRANCH_CODE}
    Input text when element is visible  //input[@title="Role"]  FMFB_BBO
    Click element when visible  //input[@name="BTN_OK"]
    Sleep   2s
    Wait until page contains element    //iframe[contains(@title,'List of Values Role')]
    Select frame   //iframe[contains(@title,'List of Values Role')]
    Wait until page contains element  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_BBO']  20s
    Click element when visible  //table[@summary="List of Values Role"]/tbody/tr/td/a[text()='FMFB_BBO']
    Unselect frame
    Sleep  2s
    Select frame  //iframe[contains (@title,'User Maintenance')]
    Select frame  //iframe[contains (@title,'Roles')]
    Click element when visible    //button[@title="Add Row"]
    Input text when element is visible  (//input[@label_value="Branch Code"])[2]  ${BRANCH_CODE}
    Input text when element is visible  (//input[@title="Role"])[2]  officer
    Click element when visible  //input[@name="BTN_OK"]


Assign Limits BBO
    Select frame    (//iframe[contains(@title,'User Maintenance')])
    Wait until page contains element  //a[contains(text(),'Limits')]  20s
    Click element when visible  //a[contains(text(),'Limits')]
    Sleep  2s
    Select frame  //iframe[contains (@title,'Limits')]
    Click element when visible  //input[@label_value="User Limits"]
    Input text when element is visible  //input[@label_value="Limit Currency"]  PKR
    Input text when element is visible  //input[@title="Maximum Transaction Amount"]  999999999
    Input text when element is visible  //input[@title="Authorization Limit"]  25000
    Click element when visible  //input[contains(@value,"Ok")]
    Select frame    (//iframe[contains(@title,'User Maintenance')])  
    Click element when visible  //a[contains(text(),"Save")] 
    
    
Capture Error Message After Saving Record in Flexcube
     Select frame  //iframe[@title="Error Message"]
     ${Error_description}  Get text  (//em[@title="Error Message"]//following::span[1])[1]
     ${Error_code}  Get text  (//em[@title="Error Message"]//following::span[2])[1]
     Click element when visible  //em[@title="Error Message"]//following::input
     Unselect frame
     
Create Trace File Of Designation not matched with the Mapping sheet
    ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
    Open Workbook    ${trace_file_name}
    Set Active Worksheet    Sheet
    ${table}   Read Worksheet As Table
    ${excel_len}   Get length  ${table}
    ${excel_len}   Evaluate   ${excel_len}+1
    Set Worksheet Value   ${excel_len}    1     ${EMPLOYEE_ID}
    Set Worksheet Value   ${excel_len}    2     ${emp_name}
    Set Worksheet Value   ${excel_len}    3     ${emp_roles}
    Set Worksheet Value   ${excel_len}    4     ${emp_comment}
    Set Worksheet Value   ${excel_len}    5     ${TICKET_ID}
    Set Worksheet Value   ${excel_len}    6     Ticket Not Resolved.${designation} Designation not matched with the Mapping sheet.
    Set Worksheet Value   ${excel_len}    7     ${START_TIME}
    Set Worksheet Value   ${excel_len}    8     ${END_TIME}
    Set Worksheet Value   ${excel_len}    9     New Flexcube User
    Set Worksheet Value   ${excel_len}    10    CBS
    Save Workbook
    Unassign Ticket
    Continue for loop
Unassign Ticket
    Wait until page contains element  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../..//child::td[7]/select
    Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../..//child::td[7]/select
    Wait until page contains element   //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../..//child::td[7]/select/option[contains(text(),'Select Identity User')]  20s
    Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../..//child::td[7]/select/option[contains(text(),'Select Identity User')]
    Sleep  2s
    Run Keyword And Ignore Error    Click element when visible  //h4[contains(text(),'Warning!')]/../../button
    

    
    
Save and Logout
    Sleep  2s
    ${Error_msg}  Does page contain element  //iframe[@id="ifr_AlertWin" and @title="Error Message"]
    Set global variable  ${Error_msg}  ${Error_msg}
    Set global variable  ${Ticket_to_be_resolve}  False
    IF  '${Error_msg}' == 'True'
        Select frame  //iframe[@title="Error Message"]
        ${Error_description}  Get text  (//em[@title="Error Message"]//following::span[1])[1]
        Set global variable  ${ERROR_DESCRIPTION}  ${Error_description}
        ${Error_code}  Get text  (//em[@title="Error Message"]//following::span[2])[1]
        Click element when visible  //em[@title="Error Message"]//following::input
        IF  'Record Already Exists for User' in '${Error_description}'
             Log  Record Already Exist
             Set global variable  ${Ticket_to_be_resolve}  True
         END
        Unselect frame
        Trace File Of Error While Saving Records In Flexcube
        send email  Exception Email  ${Error_description} on this ${id}. Kindly check at your own.
    ELSE
        Select frame  //iframe[@title="Information Message"]
        Click element when visible  //input[contains(@value,"Ok")]
        Unselect frame
        Set global variable  ${Ticket_to_be_resolve}  True
    END
    # Select frame  //iframe[contains(@title,"Information Message")]
    # Click element when visible  //input[contains(@value,"Ok")]
    # Unselect frame
    Wait until page contains element    //iframe[contains (@title,'User Maintenance')]
    Select frame    //iframe[contains (@title,'User Maintenance')]
    Click element when visible   //input[@id="BTN_EXIT_IMG"]
    Sleep  1s
    Press Keys  None  ENTER
    # ${confirmatiob_msg}  Does page contain element  //iframe[@title="Confirmation Message"]
    # IF  '${confirmatiob_msg}' == 'True'
    #     Unselect frame
    #     Select frame  //iframe[@title="Confirmation Message"]
    #     Click button when visible   (//em[@title="Confirmation Message"]//following::input)[1]
    #     Unselect frame
    # END
    Unselect frame
    Select frame    //iframe[contains (@title,'User Maintenance')]
    Click element when visible   //input[@id="BTN_EXIT_IMG"]
    Wait Until Page Contains Element  //iframe[contains (@title,'User Summary')]  20
    Select frame     //iframe[contains (@title,'User Summary')]
    Click element when visible   //input[@id="BTN_EXIT"]
    Click element when visible   //a[contains(text(),'Sign Off')]
    Wait until page contains element    //iframe[@id="ifr_AlertWin"]
    Sleep  1s
    Unselect frame
    Sleep  2s
    Select frame   //iframe[@id="ifr_AlertWin"]
    Click element when visible  //*[contains(@title,"Ok")]
    Press Keys  None  ENTER
    Sleep  2s
    Close window
    Switch window  MAIN
    IF  '${Ticket_to_be_resolve}' == 'False'
        log  unasign ticket
        Unassign ticket
        send email  Exception Email  Error Message  ${Error_description} ${id}. Kindly check at your own.
    ELSE
        CIM_New_Flexcube_User.Resolve Ticket
    END
    
Trace File Of Error While Saving Records In Flexcube
    ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
    Open Workbook    ${trace_file_name}
    Set Active Worksheet    Sheet
    ${table}   Read Worksheet As Table
    ${excel_len}   Get length  ${table}
    ${excel_len}   Evaluate   ${excel_len}+1
    Set Worksheet Value   ${excel_len}    1     ${EMPLOYEE_ID}
    Set Worksheet Value   ${excel_len}    2     ${emp_name}
    Set Worksheet Value   ${excel_len}    3     ${emp_roles}
    Set Worksheet Value   ${excel_len}    4     ${emp_comment}
    Set Worksheet Value   ${excel_len}    5     ${Ticket_ID}
    Set Worksheet Value   ${excel_len}    6     Ticket Not Resolved. ${ERROR_DESCRIPTION}.
    Set Worksheet Value   ${excel_len}    7     ${START_TIME}
    Set Worksheet Value   ${excel_len}    8     ${END_TIME}
    Set Worksheet Value   ${excel_len}    9     New Flexcube User
    Set Worksheet Value   ${excel_len}    10    CBS
    Save Workbook
Resolve Ticket
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
        Input text when element is visible  //textarea[@id="comments"]   ${FIRST_NAME}${EMPLOYEE_ID} ${RANDOM_PASS}
        Click element when visible  //button[contains(text(),'Change Status')]
        Execute Javascript    window.open('${Flexcube_URL}')
        Switch window    NEW
        Sleep  2s
        Select frame  //iframe[@id='ifr_AlertWin']
        Click element when visible  //*[contains(@title,"Ok")]
        Unselect frame
        CIM_New_Flexcube_User.Authorize ticket from checker ID
    ELSE
        ${tickets}   Get Element Count    //table[contains(@class,"table")]/tbody/tr/td[3]/b
        FOR  ${i}  IN RANGE  1  ${tickets}+1
            ${id_in_CIM}   Get text  (//table[contains(@class,"table")]/tbody/tr/td[3]/b)[${i}]/../../td[1]/b
            IF  '${id_in_CIM}' == '${TICKET_ID}'
                Wait until page contains element  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button  20s
                Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button
                Sleep  3s
                Wait until element is visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button//following::ul[1]/li[3]/a  20s
                Click element when visible  //table[@class="table table-hover table-striped"]//child::td/b[contains(text(),'${TICKET_ID}')]/../../td[13]/div/button//following::ul[1]/li[3]/a
                Wait until element is visible  //textarea[@id="comments"]  20s
                Input text when element is visible  //textarea[@id="comments"]   ${EMPLOYEE_ID}  ${RANDOM_PASS}
                Click element when visible  //button[contains(text(),'Change Status')]
                Execute Javascript    window.open('${Flexcube_URL}')
                Switch window    NEW
                Sleep  2s
                Select frame  //iframe[@id='ifr_AlertWin']
                Click element when visible  //*[contains(@title,"Ok")]
                Unselect frame
                CIM_New_Flexcube_User.Authorize ticket from checker ID
                Log  Ticket foudnd
            ELSE
                log  no ticket found while resolving the ticket
                send email  Exception Email  Error Message No ticket found while resolving the ticket. Kindly check at your own.
            END
        END
        Log   Ticket not found after reloading page
        send email  Exception Email  Error Message Failed to Modify the record ${id}. Kindly check at your own.
    END
    [Return]    ${check_element_after_refresh}
    
Trace File Of Branch Code Not Found
    ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S           
     Log   Branch code not found
     Open Workbook    ${trace_file_name}
     Set Active Worksheet    Sheet
     ${table}   Read Worksheet As Table
     ${excel_len}   Get length  ${table}
     ${excel_len}   Evaluate   ${excel_len}+1
     Set Worksheet Value   ${excel_len}    1     ${EMPLOYEE_ID}
     Set Worksheet Value   ${excel_len}    2     ${emp_name}
     Set Worksheet Value   ${excel_len}    3     ${emp_roles}
     Set Worksheet Value   ${excel_len}    4     ${emp_comment}
     Set Worksheet Value   ${excel_len}    5     ${Ticket_ID}
     Set Worksheet Value   ${excel_len}    6     Ticket Not Resolved. ${HOME_BRANCH} Branch Name and Code not found in the Mapping Sheet.
     Set Worksheet Value   ${excel_len}    7     ${START_TIME}
     Set Worksheet Value   ${excel_len}    8     ${END_TIME}
     Set Worksheet Value   ${excel_len}    9     New Flexcube User
     Set Worksheet Value   ${excel_len}    10    CBS
     Save Workbook
     Unassign Ticket

Trace File Of Ticket Resolved Successfully
    ${END_TIME}    Get Current Date    result_format=%d-%b-%Y %H-%M-%S
    Open Workbook    ${trace_file_name}
    Set Active Worksheet    Sheet
    ${table}   Read Worksheet As Table
    ${excel_len}   Get length  ${table}
    ${excel_len}   Evaluate   ${excel_len}+1
    Set Worksheet Value   ${excel_len}    1     ${EMPLOYEE_ID}
    Set Worksheet Value   ${excel_len}    2     ${emp_name}
    Set Worksheet Value   ${excel_len}    3     ${emp_roles}
    Set Worksheet Value   ${excel_len}    4     ${emp_comment}
    Set Worksheet Value   ${excel_len}    5     ${Ticket_ID}
    Set Worksheet Value   ${excel_len}    6     Ticket Resolved Sucessfully
    Set Worksheet Value   ${excel_len}    7     ${START_TIME}
    Set Worksheet Value   ${excel_len}    8     ${END_TIME}
    Set Worksheet Value   ${excel_len}    9     New Flexcube User
    Set Worksheet Value   ${excel_len}    10    CBS
    Save Workbook

Authorize ticket from checker ID
    # Open Available Browser   ${Flexcube_URL}    browser_selection=Chrome  maximized=True
    Select frame  //*[@id="ifr_AlertWin"]
    Click element when visible  //*[contains(@title,"Ok")]
    Unselect frame
    Input text when element is visible  //input[contains(@id,"USERID")]    ${Checkerusername}
    Input text when element is visible   //input[contains(@id,"user_pwd")]    ${checkerpassword}
    Click element when visible  //*[contains(@value,"Sign In")]
    ${User_Login}=  Check User Log In
    log  ${User_Login}
    IF  '${User_Login}' == 'True'
        log  Plaese Clear The User
        Click element when visible  //*[contains(@title,"Ok")]
        Cleared The LogedIn User  ${flexcube_username}  ${flexcube_password}  ${flexcube_username}
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
    
    ${name}=    Convert To Uppercase   ${emp_name}
    Sleep   2s
    ${record_available}=   Does page contain element   //iframe[contains(@title,'Information Message')]
    IF  ${record_available} == False
        ${checker_record}   Run keyword and return status   Double click element    (//*[contains(text(),'Unauthorized')]/../../../..)[3]/tbody/tr//td[9]/a[contains(text(),'${EMPLOYEE_ID}')]//..//..//td[11]/a[contains(text(),'${name}')]
        IF  ${checker_record} == False
            log  update trace file
            # Open Workbook    ${trace_file_name}
            # Set Active Worksheet    Sheet
            # Set Worksheet Value   ${excel_len}    6     Business Exception Not Resolved, Ticket not found on CHCKER
            # Save workbook
        ELSE
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
                    Unselect frame
                    Wait until element is visible   //iframe[contains (@title,'User Maintenance')]  
                    Select frame    //iframe[contains (@title,'User Maintenance')]
                    ${RPA_MKR}   Does page contain element   //input[contains(@value,'${MAKER_NAME}')]
                    IF  '${RPA_MKR}' == 'True'
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
                    ELSE
                        Wait until page contains element    //iframe[contains (@title,'User Maintenance')]
                        Select frame    //iframe[contains (@title,'User Maintenance')]
                        Click element when visible   //input[@id="BTN_EXIT_IMG"]
                        Log   No additional ticket are available for authorize
                    END
                END      
            END                                                                                                                                          # Check if any auth end here 
           
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
        Select frame   //iframe[contains(@title,'Information Message')]
        Click element when visible  //*[contains(@title,"Ok")]
        send email  Exception Email   Record not found in checker${id}. Kindly check at your own.
    END
    Unselect frame
    Close window
    
    
    
#         *** Tasks ***
#         CIM New User Creation
#             Open the CIM URL   
#             ${login_status}  Check Login sucessfull or not for CIM
#             IF  '${login_status}' == 'False'
#                 log  Sucessfully Login to CIM
#                 Get tickets Count from CIM
#                 FOR  ${i}  IN RANGE  1  ${TICKETS}+1
#                     ${Ticket_Subject}=  Get Subject and ID of Tickets    ${i}
#                     IF  '${Ticket_Subject}' == 'New Flexcube User'
#                         ${designation}  Extact Data From Ticket    ${i}
#                         Check Designation From Ticket    ${designation}
#                         ${BRANCH_CODE_EXIST}   Fetch Branch Code From Excel
#                         IF  '${BRANCH_CODE_EXIST}' == 'True'
#                             Open The Flexcube URL
#                             Login to Felxcube
#                             Search Details Query id In Flexcube
#                             Fill Form In Flexcube
#                             Select Checkboxes in Form For Designation
#                             Save and Logout
#                             IF  '${Error_msg}' == 'False'
#                                 Trace File Of Ticket Resolved Successfully
#                             END
#                         ELSE
#                             Trace File Of Branch Code Not Found
#                         END
#                     END
#                 END
#             END