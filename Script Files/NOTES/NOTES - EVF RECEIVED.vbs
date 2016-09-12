'*******************Need to finish the case note piece of this. The header needs to include the date received and the EVF status
                   'Need to work on the Tikl checkbox- we decided it will be autochecked  





'Required for statistical purposes==========================================================================================
name_of_script = "NOTES - EVF RECEIVED.vbs"
start_time = timer
STATS_counter = 1               'sets the stats counter at one
STATS_manualtime = 120          'manual run time in seconds
STATS_denomination = "C"        'C is for each case
'END OF stats block=========================================================================================================

'LOADING FUNCTIONS LIBRARY FROM GITHUB REPOSITORY===========================================================================
IF IsEmpty(FuncLib_URL) = TRUE THEN	'Shouldn't load FuncLib if it already loaded once
	IF run_locally = FALSE or run_locally = "" THEN	   'If the scripts are set to run locally, it skips this and uses an FSO below.
		IF use_master_branch = TRUE THEN			   'If the default_directory is C:\DHS-MAXIS-Scripts\Script Files, you're probably a scriptwriter and should use the master branch.
			FuncLib_URL = "https://raw.githubusercontent.com/MN-Script-Team/BZS-FuncLib/master/MASTER%20FUNCTIONS%20LIBRARY.vbs"
		Else											'Everyone else should use the release branch.
			FuncLib_URL = "https://raw.githubusercontent.com/MN-Script-Team/BZS-FuncLib/RELEASE/MASTER%20FUNCTIONS%20LIBRARY.vbs"
		End if
		SET req = CreateObject("Msxml2.XMLHttp.6.0")				'Creates an object to get a FuncLib_URL
		req.open "GET", FuncLib_URL, FALSE							'Attempts to open the FuncLib_URL
		req.send													'Sends request
		IF req.Status = 200 THEN									'200 means great success
			Set fso = CreateObject("Scripting.FileSystemObject")	'Creates an FSO
			Execute req.responseText								'Executes the script code
		ELSE														'Error message
			critical_error_msgbox = MsgBox ("Something has gone wrong. The Functions Library code stored on GitHub was not able to be reached." & vbNewLine & vbNewLine &_
                                            "FuncLib URL: " & FuncLib_URL & vbNewLine & vbNewLine &_
                                            "The script has stopped. Please check your Internet connection. Consult a scripts administrator with any questions.", _
                                            vbOKonly + vbCritical, "BlueZone Scripts Critical Error")
            StopScript
		END IF
	ELSE
		FuncLib_URL = "C:\BZS-FuncLib\MASTER FUNCTIONS LIBRARY.vbs"
		Set run_another_script_fso = CreateObject("Scripting.FileSystemObject")
		Set fso_command = run_another_script_fso.OpenTextFile(FuncLib_URL)
		text_from_the_other_script = fso_command.ReadAll
		fso_command.Close
		Execute text_from_the_other_script
	END IF
END IF
'END FUNCTIONS LIBRARY BLOCK================================================================================================



BeginDialog EVF_received, 0, 0, 276, 210, "Employment Verification Form Received"
  EditBox 80, 45, 100, 15, date_received
  EditBox 80, 85, 100, 15, client
  EditBox 80, 65, 100, 15, employer
  DropListBox 80, 105, 50, 20, "Select one"+chr(9)+"yes"+chr(9)+"no", info
  EditBox 200, 105, 60, 15, info_date
  EditBox 80, 125, 100, 15, request_info
  EditBox 80, 145, 180, 15, notes
  EditBox 80, 165, 100, 15, worker_signature
  ButtonGroup ButtonPressed
    OkButton 150, 190, 50, 15
    CancelButton 215, 190, 50, 15
  Text 5, 170, 60, 10, "Worker Signature:"
  Text 5, 50, 65, 10, "Date EVF received:"
  Text 140, 105, 60, 10, "Date Requested:"
  Text 5, 130, 65, 10, "Info Requested via:"
  Text 5, 110, 60, 10, "Addt'l Info Reqstd"
  Text 5, 90, 65, 10, "Household Member"
  Text 5, 70, 55, 10, "Employer name:"
  Text 5, 150, 70, 10, "Action taken / Notes:"
  ComboBox 80, 25, 170, 45, "Select One..."+chr(9)+"Signed by Client & Completed by Employer "+chr(9)+"Signed by Client"+chr(9)+"Completed by Employer", EVF_status_dropdown
  Text 5, 30, 45, 10, "EVF Status "
  CheckBox 5, 185, 80, 10, "Tikl for EVF Return ", Tikl_checkbox
  Text 5, 10, 50, 10, "Case Number"
  EditBox 80, 5, 70, 15, Case_number
EndDialog


'connects to BlueZone and brings it forward
EMConnect ""
EMFocus

'checks that the worker is in MAXIS - allows them to get in MAXIS without ending the script
Call check_for_MAXIS(false)

'grabs the case number and benefit month/year that is being worked on
call MAXIS_case_number_finder(MAXIS_case_number)


' >>>>> GATHERING & CONFIRMING THE MAXIS CASE NUMBER <<<<<


CALL check_for_MAXIS(False)

'starts the EVF received case note dialog
DO
	Do
		err_msg = ""
		'starts the EVF dialog
		Dialog EVF_received
		'asks if you want to cancel and if "yes" is selected sends StopScript
		cancel_confirmation 
		'checks that there is a date in the date received box
		If EVF_status_dropdown = "Select One..." THEN err_msg = err_msg & vbCr & "You must select the status of the EVF on the dropdown menu"
		IF IsDate (date_received) = FALSE THEN err_msg = err_msg & vbCr & "You must enter a date in mm/dd/yy for date received."
		'checks if the client name has been entered
		IF client = "" THEN err_msg = err_msg & vbCr & "You must enter the MEMB #."
		'checks if the employer name has been entered
		IF employer = "" THEN err_msg = err_msg & vbCr & "You must enter the employers name."
		'checks if completed by employer was selected
		IF info = "Select one" THEN err_msg = err_msg & vbCr & "You must select if additional info was requested."
		'checks that there is a info request date entered if the it was requested
		IF info = "yes" and IsDate (info_date) = FALSE THEN err_msg = err_msg & vbCr & "You must enter a date in mm/dd/yy that additional info was requested."
		'checks that there is a method of inquiry entered if additional info was requested
		IF info = "yes" and request_info = "" THEN err_msg = err_msg & vbCr & "You must enter the method used to request additional info."
		'checks that notes were entered				
		IF notes = "" THEN err_msg = err_msg & vbCr & "You must enter action taken/notes."
		'checks that the case note was signed
		IF worker_signature = "" THEN err_msg = err_msg & vbCr & "You must sign your case note!" 
		IF err_msg <> "" THEN MsgBox "*** NOTICE!!! ***" & vbCr & err_msg & vbCr & vbCr & "Please resolve for the script to continue."
	LOOP UNTIL err_msg = ""
	call check_for_password(are_we_passworded_out)  'Adding functionality for MAXIS v.6 Passworded Out issue'
LOOP UNTIL are_we_passworded_out = false			


'checks that the worker is in MAXIS - allows them to get in MAXIS without ending the script
call check_for_MAXIS (false)

'starts a blank case note
call start_a_blank_case_note
'this enters the actual case note info 
call write_variable_in_CASE_NOTE("***EVF received " & date_received & " is " & EVF_status & "***")
call write_bullet_and_variable_in_CASE_NOTE("Date Received", date_received)
call write_variable_in_CASE_NOTE("* MEMB #/Employer: MEMB " & client & " at " & employer)
call write_bullet_and_variable_in_CASE_NOTE("Signed by client", signed_by_client)
call write_bullet_and_variable_in_CASE_NOTE("Completed by employer", complete)
	'case note changes based on if additional info was requested
	IF info = "yes" then call write_variable_in_CASE_NOTE ("* Additional Info requested: " & info & " on " & info_date)
	IF info = "no" then call write_variable_in_CASE_NOTE ("* Additional Info requested: " & info)
call write_bullet_and_variable_in_CASE_NOTE("Request method used", request_info)
call write_bullet_and_variable_in_CASE_NOTE("Action Taken/Notes", notes)
	'case notes that a TIKL was set if additional information was requested
	IF info = "yes" THEN call write_variable_in_CASE_NOTE ("***TIKLed for 10 day return.***")
call write_variable_in_CASE_NOTE ("---")
call write_variable_in_CASE_NOTE(worker_signature)

'Checks if additional info is yes and sets a TIKL for the return of the info
IF info = "yes" THEN 
	call navigate_to_MAXIS_screen("dail", "writ")

	'The following will generate a TIKL formatted date for 10 days from now.
	call create_MAXIS_friendly_date(date, 10, 5, 18)

	'Writing in the rest of the TIKL.
	call write_variable_in_TIKL("Additional info requested after an EVF being rec'd should have returned by now. If not received, take appropriate action. (TIKL auto-generated from script)." )
	transmit
	PF3

	'Success message
	MsgBox "Success! TIKL has been sent for 10 days from now for the additional information requested."

End if
script_end_procedure("")
