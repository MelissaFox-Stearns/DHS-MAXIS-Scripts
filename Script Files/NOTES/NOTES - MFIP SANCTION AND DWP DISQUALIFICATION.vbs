BeginDialog MFIP_Sanction_DWP_Disq_Dialog, 0, 0, 346, 330, "MFIP Sanction - DWP Disqualification"
  EditBox 55, 5, 60, 15, MAXIS_case_number
  EditBox 180, 5, 25, 15, HH_Member_Number
  DropListBox 265, 5, 65, 15, "Select one..."+chr(9)+"imposed"+chr(9)+"pending", sanction_status_droplist
  DropListBox 65, 25, 110, 15, "Select one..."+chr(9)+"CS"+chr(9)+"ES"+chr(9)+"Dual (ES & CS)"+chr(9)+"No show to orientation"+chr(9)+"Minor mom truancy", sanction_type_droplist
  EditBox 265, 25, 50, 15, number_occurances
  DropListBox 50, 45, 65, 15, "Select one..."+chr(9)+"10%"+chr(9)+"30%"+chr(9)+"100%", Sanction_Percentage_droplist
  EditBox 265, 45, 65, 15, Date_Sanction
  ComboBox 90, 65, 240, 45, "Select one..."+chr(9)+"Failed to attend ES overview"+chr(9)+"Failed to develop employment plan"+chr(9)+"Non-compliance with employment plan"+chr(9)+"< 20, failed education requirement"+chr(9)+"Failed to accept suitable employment"+chr(9)+"Quit suitable employment w/o good cause"+chr(9)+"Failure to attend MFIP orientation"+chr(9)+"Non-cooperation with child support", sanction_reason_droplist
  EditBox 90, 85, 240, 15, sanction_information
  EditBox 90, 105, 140, 15, ES_counselor_name
  EditBox 265, 105, 65, 15, ES_counselor_phone
  EditBox 90, 125, 240, 15, other_sanction_notes
  EditBox 90, 145, 240, 15, Impact_Other_Programs
  EditBox 90, 165, 240, 15, Vendor_Information
  CheckBox 10, 185, 300, 10, "*Click Here* IF sanction # is between 3 to 6, AND the sanction is for consecutive months", consecutive_sanction_months
  Text 10, 200, 325, 10, "**Last day to cure (10 days or 1 day prior to the effective month - this will be in the case note)**"
  CheckBox 10, 225, 130, 10, "Update sent to Employment Services", Update_Sent_ES_Checkbox
  CheckBox 150, 225, 190, 10, "Sent MFIP sanction for future closed month SPEC/LETR", Sent_SPEC_WCOM
  CheckBox 10, 240, 130, 10, "Update sent to Child Care Assistance", Update_Sent_CCA_Checkbox
  CheckBox 150, 250, 130, 10, "TIKL to change sanction status ", TIKL_next_month
  CheckBox 10, 260, 80, 10, "Case has been FIAT'd", Fiat_check
  CheckBox 150, 275, 145, 10, "If you want script to write to SPEC/WCOM", notating_spec_wcom
  CheckBox 10, 275, 140, 10, "Mandatory vendor form mailed to client", mandatory_vendor_check
  EditBox 150, 300, 75, 15, worker_signature
  ButtonGroup ButtonPressed
    OkButton 235, 300, 50, 15
    CancelButton 290, 300, 50, 15
  Text 5, 10, 45, 10, "Case number:"
  Text 130, 10, 50, 10, "HH Member #:"
  Text 210, 10, 55, 10, "Sanction status:"
  Text 5, 30, 60, 10, "Type of sanction:"
  Text 185, 30, 75, 10, "Number of occurences:"
  Text 5, 50, 40, 10, "Sanction %:"
  Text 125, 50, 140, 10, "Effective Date of Sanction/Disqualification:"
  Text 5, 70, 80, 10, "Reason for the sanction:"
  Text 5, 90, 80, 10, "Sanction info from/how:"
  Text 5, 110, 65, 10, "CS/ES Counselor:"
  Text 235, 110, 25, 10, "Phone:"
  Text 5, 130, 70, 10, "Other sanction notes:"
  Text 5, 150, 85, 10, "Impact to other programs:"
  Text 5, 170, 65, 10, "Vendor information:"
  GroupBox 5, 215, 340, 85, "Check all that apply:"
  Text 160, 235, 160, 10, "(See TE10.20 for info on when to use this notice)"
  Text 160, 260, 175, 10, "(If the sanction status will change for next month)"
  Text 160, 285, 125, 10, "(Check only if MFIP/DWP is approved)"
  Text 85, 305, 60, 10, "Worker signature:"
EndDialog
