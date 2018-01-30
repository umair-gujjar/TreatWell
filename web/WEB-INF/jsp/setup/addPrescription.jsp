<%-- 
    Document   : addPrescription
    Created on : Oct 6, 2017, 12:25:54 PM
    Author     : farazahmad
--%>
<%@include file="../header.jsp"%>
<script>
    var medicines = [];
    $(function () {
        getAppointedPatientsForDoctor();
        $('.select2_category').select2({
            placeholder: "Select an option",
            allowClear: true
        });
        $('.icheck').iCheck({
            checkboxClass: 'icheckbox_square',
            radioClass: 'iradio_square'
        });
        $('.icheck').iCheck('disable');
        $('#panelPatient').hide();
        $('#balanceInfo').hide();
    });
    function getCollectionCenter(param) {
        //Find all areas
        var tr = $(param).closest('tr');
        var select = tr.find('select[name=collectionCenterId]');
        $(select).find('option').remove();
        if ($(param).val() !== '') {
            $.get('performa.htm?action=getLabCollectionCenter', {medicalLabId: $(param).val()}, function (data) {
                $('<option />', {value: '', text: 'Please select center'}).appendTo($(select));
                if (data !== null && data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        $('<option />', {value: data[i].TW_LAB_DETAIL_ID, text: data[i].CENTER_NME}).appendTo($(select));
                    }
                } else {
                    $('<option />', {value: '', text: 'No Center Found'}).appendTo($(select));
                }
                $(select).select2("val", "").trigger('change');
            }, 'json');
        }
    }
    function saveData() {
        var medicineName = [], medicineDays = [], medicineQty = [], medicineFrequency = [], medicineInstructions = [];
        var labIdArr = [], labCenterIdArr = [], occurrenceArr = [];
        ;
        var labTestIdArr = [];
        var tr = $('#medicineTable').find('tbody').find('tr');
        var flag = true;
        if ($(tr).length === 1) {
            var td = $(tr).find('td');
            var field = null;
            var fl = false;
            $.each(td, function (index, innerObj) {
                if (index === 0) {
                    if ($(innerObj).find('select').val() !== '') {
                        medicineName.push($(innerObj).find('select').val());
                        fl = true;
                    }
                }
                if (index === 1 && fl) {
                    medicineDays.push($(innerObj).find('input:text').val());

                }
                if (index === 2 && fl) {
                    medicineQty.push($(innerObj).find('input:text').val());
                }
                if (index === 3 && fl) {
                    medicineFrequency.push($(innerObj).find('select').val());
                }
                if (index === 4 && fl) {
                    medicineInstructions.push($(innerObj).find('select').val());
                }


            });

        } else if ($(tr).length > 1) {
            $.each(tr, function (index, obj) {
                var td = $(obj).find('td');
                var field = null;
                $.each(td, function (index, innerObj) {
                    if (index === 0) {
                        medicineName.push($(innerObj).find('select').val());
                        if ($(innerObj).find('select').val() === '') {
                            flag = false;
                            field = $(innerObj).find('select');
                        }
                    }
                    if (index === 1) {
                        medicineDays.push($(innerObj).find('input:text').val());
                        if ($(innerObj).find('input:text').val() === '') {
                            flag = false;
                            field = $(innerObj).find('input:text');
                        }
                    }
                    if (index === 2) {
                        medicineQty.push($(innerObj).find('input:text').val());
                        if ($(innerObj).find('input:text').val() === '') {
                            flag = false;
                            field = $(innerObj).find('input:text');
                        }
                    }
                    if (index === 3) {
                        medicineFrequency.push($(innerObj).find('select').val());
                    }
                    if (index === 4) {
                        medicineInstructions.push($(innerObj).find('select').val());
                    }
                });

            });
        }
        flag = true;
        tr = $('#testTable').find('tbody').find('tr');
        if ($(tr).length === 1) {
            var td = $(tr).find('td');
            var field = null;
            $.each(td, function (index, innerObj) {
                if (index === 0) {
                    if ($(innerObj).find('select').val() !== '') {
                        labTestIdArr.push($(innerObj).find('select').val());
                    }
                } else if (index === 1) {
                    if ($(innerObj).find('select').val() !== '') {
                        labIdArr.push($(innerObj).find('select').val());
                    }
                } else if (index === 2) {
                    if ($(innerObj).find('select').val() !== '') {
                        labCenterIdArr.push($(innerObj).find('select').val());
                    }
                } else if (index === 3) {
                    occurrenceArr.push($(innerObj).find('input:text').val());
                }
            });
        } else if ($(tr).length > 1) {
            var flg = true;
            $.each(tr, function (index, obj) {
                var td = $(obj).find('td');
                var field = null;
                $.each(td, function (index, innerObj) {
                    if (index === 0 && flg) {
                        labTestIdArr.push($(innerObj).find('select').val());
                        if ($(innerObj).find('select').val() === '') {
                            flg = false;
                            field = $(innerObj).find('select');
                        }
                    } else if (index === 1 && flg) {
                        if ($(innerObj).find('select').val() !== '') {
                            labIdArr.push($(innerObj).find('select').val());
                        }
                    } else if (index === 2 && flg) {
                        if ($(innerObj).find('select').val() !== '') {
                            labCenterIdArr.push($(innerObj).find('select').val());
                        }
                    } else if (index === 3 && flg) {
                        occurrenceArr.push($(innerObj).find('input:text').val());
                    }
                });

            });
            if (!flg) {
                $(field).notify('Select a test or remove this row.', 'error');
                return false;
            }
        }
        if (flag) {
            if ($('#patientId').val() === '') {
                $('#patientId').notify('Select a patient to save prescription.', 'error');
                $('#patientId').focus();
                return false;
            }
            $.post('performa.htm?action=savePrescription', {
                patientId: $('#patientId').val(), remarks: $('#comments').val(), 'medicineIdArr[]': medicineName,
                'daysArr[]': medicineDays, 'qtyArr[]': medicineQty, 'frequencyIdArr[]': medicineFrequency,
                'usageIdArr[]': medicineInstructions, 'labIdArr[]': labIdArr, 'labTestIdArr[]': labTestIdArr,
                'labCenterIdArr[]': labCenterIdArr,'occurrenceArr[]':occurrenceArr
            }, function (obj) {
                if (obj.msg === 'saved') {
                    $.bootstrapGrowl("Prescription saved successfully.", {
                        ele: 'body',
                        type: 'success',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10
                    });
                    getAppointedPatientsForDoctor();
                    $('#comments').val('');
                    document.getElementById("prescForm").action = 'performa.htm?action=printPrescription&id=' + obj.masterId;
                    document.getElementById("prescForm").target = '_blank';
                    document.getElementById("prescForm").submit();
                    $('#medicineTable').find('tbody').find('tr').not(':eq(0)').remove();
                } else if (obj.msg === 'error') {
                    $.bootstrapGrowl("Error in saving prescription.", {
                        ele: 'body',
                        type: 'danger',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10
                    });
                } else {
                    $.bootstrapGrowl("Doctor do not have a clinic defined. Please contact system administrator.", {
                        ele: 'body',
                        type: 'danger',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10
                    });
                }
            }, 'json');
        }
        return false;
    }
    function fillValue(param) {
        if ($.trim(param.value) !== null && $.trim(param.value) !== '') {
            var nextTd = $(param).parent().next();
            $(nextTd).find('input:text').val('1');
            var nextTd = $(param).parent().next().next();
            $(nextTd).find('input:text').val('1');
        }
    }
    function addRow(param) {
        var tr = $(param).parent().parent().clone();
        tr.find('input:text').val('1');
        var select = tr.find('select');
        select.removeClass('select2-offscreen');
        tr.find('td:eq(0)').html('');
        tr.find('td:eq(0)').html(select[0]);
        tr.find('td:eq(3)').html('');
        tr.find('td:eq(3)').html(select[1]);
        tr.find('td:eq(4)').html('');
        tr.find('td:eq(4)').html($(select[2]).select2("val", ""));
        tr.find('td:last').html('');
        tr.find('td:last').html('<button type="button" class="btn btn-sm red" onclick="removeRow(this);" ><i class="fa fa-minus-circle" aria-hidden="true"></i></button>');
        var tbody = $(param).parent().parent().parent();
        tr.appendTo(tbody);
        tr.find('select').select2({
            placeholder: "Select an option",
            allowClear: true
        });
    }
    function addLabTestRow(param) {
        var tr = $(param).parent().parent().clone();
        tr.find('input:text').val('');
        var select = tr.find('select');
        select.removeClass('select2-offscreen');
        tr.find('td:eq(0)').html('');
        tr.find('td:eq(0)').html(select[0]);
        tr.find('td:eq(1)').html('');
        tr.find('td:eq(1)').html(select[1]);
        tr.find('td:eq(2)').html('');
        tr.find('td:eq(2)').html(select[2]);
        tr.find('td:last').html('');
        tr.find('td:last').html('<button type="button" class="btn btn-sm red" onclick="removeRow(this);" ><i class="fa fa-minus-circle" aria-hidden="true"></i></button>');
        var tbody = $(param).parent().parent().parent();
        tr.appendTo(tbody);
        tr.find('select').select2({
            placeholder: "Select an option",
            allowClear: true
        });
    }
    function removeRow(param) {
        $(param).closest('tr').remove();
    }
    function viewPatientInfo() {
        $.get('setup.htm?action=getPatientById', {patientId: $('#patientId').val()},
                function (obj) {
                    $('#patientName').val(obj.PATIENT_NME);
                    $('#cityId').val(obj.CITY_NME);
                    $('#contactNo').val(obj.MOBILE_NO);
                    $('#address').val(obj.ADDRESS);
                    $('#referredBy').val(obj.REFERRED_BY);
//                    $('#viewPatientModal').modal('show');
                }, 'json');
    }
    function getPrescription() {
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th class="center" width="5%">').html('Sr. #'),
                $('<th class="center" width="30%">').html('Patient Name'),
                $('<th class="center" width="40%">').html('Remarks'),
                $('<th class="center" width="10%">').html('Date'),
                $('<th class="center" width="15%" colspan="2">').html('&nbsp;')
                )));
        $.get('clinic.htm?action=getPrescriptionListing', {patientId: $('#patientId').val(), dateFrom: null,
            dateTo: null},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        for (var i = 0; i < list.length; i++) {
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td align="center">').html(eval(i + 1)),
                                    $('<td>').html(list[i].PATIENT_NME),
                                    $('<td>').html(list[i].REMARKS),
                                    $('<td >').html(list[i].PREPARED_DTE),
                                    $('<td align="center">').html('<i class="fa fa-print" aria-hidden="true" title="Click to Print" style="cursor: pointer;" onclick="printPrescription(\'' + list[i].TW_PRESCRIPTION_MASTER_ID + '\');"></i>')
                                    ));
                        }
                        $('#prescriptionDiv').html('');
                        $('#prescriptionDiv').append($tbl);
                        return false;
                    } else {
                        $('#prescriptionDiv').html('');
                        $tbl.append(
                                $('<tr>').append(
                                $('<td  colspan="6">').html('<b>No data found.</b>')
                                ));
                        $('#prescriptionDiv').append($tbl);
                        return false;
                    }
                }, 'json');
    }
    function getDiseases() {
        var $tbl = $('<div class="row">');
        $.get('setup.htm?action=getPatientDiseasesById', {patientId: $('#patientId').val()},
                function (obj) {
                    if (obj !== null && obj.length > 0) {
                        $('input:checkbox[name="patientDiseases"]').iCheck('uncheck');
                        for (var i = 0; i < obj.length; i++) {
                            $tbl.append(
                                    $('<div class="col-md-6">').append('<i class="fa fa-check danger"></i> ' + obj[i].TITLE
                                    ));
                            $('input:checkbox[name="patientDiseases"][value="' + obj[i].TW_DISEASE_ID + '"]').iCheck('check');
                        }
                    } else {
                        $tbl.append(
                                $('<div class="col-md-12 danger">').append('No Disease Found'));
                    }
                    $('#diseaseDiv').html('');
                    $('#diseaseDiv').append($tbl);
                }, 'json');
    }
    function attachReport() {
        displayReportAttachements();
        $('#attachModal').modal('show');
    }
    function saveReports() {
        var data = new FormData(document.getElementById('reportAttachmentFrom'));
        data.append('patientId', $('#patientId').val());
        $.ajax({
            url: "setup.htm?action=savePatientReports",
            type: "POST",
            data: data,
            cache: false,
            dataType: 'json',
            processData: false, // tell jQuery not to process the data
            contentType: false   // tell jQuery not to set contentType

        }).done(function (data) {
            if (data) {
                if (data.result === 'save_success') {
                    $.bootstrapGrowl("Report Upload successfully.", {
                        ele: 'body',
                        type: 'success',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10

                    });
                    displayReportAttachements();

                } else {
                    $.bootstrapGrowl("Error in Report Uploading.", {
                        ele: 'body',
                        type: 'danger',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10
                    });
                    $('#addAttachements').modal('hide');
                }
            }
        });
    }
    function viewInTakeForm() {
        $.get('setup.htm?action=getPatientById', {patientId: $('#patientId').val()},
                function (obj) {
                    $('input:radio[name="smoker"][value="' + obj.SMOKER_IND + '"]').iCheck('check');
                    $('input:radio[name="allergy"][value="' + obj.ANY_ALLERGY + '"]').iCheck('check');
                    $('input:radio[name="medicineOpt"][value="' + obj.TAKE_MEDICINE + '"]').iCheck('check');
                    $('input:radio[name="steroidOpt"][value="' + obj.TAKE_STEROID + '"]').iCheck('check');
                    $('input:radio[name="attendClinic"][value="' + obj.ATTEND_CLINIC + '"]').iCheck('check');
                    $('input:radio[name="Rheumatic"][value="' + obj.ANY_FEVER + '"]').iCheck('check');
                    $('#inTakeForm').modal('show');
                }, 'json');
    }
    function getAppointedPatientsForDoctor() {
        //Find all characters
        $('#patientId').find('option').remove();
        $.get('performa.htm?action=getAppointedPatientsForDoctor', function (data) {
            if (data !== null && data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    $('<option />', {value: data[i].TW_PATIENT_ID, text: data[i].PATIENT_NME + " [" + data[i].MOBILE_NO + "]"
                        , companyId: data[i].TW_COMPANY_ID, balance: data[i].BALANCE}).appendTo($('#patientId'));
                }
            } else {
                $('<option />', {value: '', text: 'No patiend is appointed yet.'
                    , companyId: '', balance: '0'}).appendTo($('#patientId'));
            }
            $('#patientId').select2({
                placeholder: "Select a patient",
                allowClear: true
            });
            $('#patientId').change(function () {
                var selected = $(this).find('option:selected');
                (selected.attr('companyId') !== '' ? $('#panelPatient').show() : $('#panelPatient').hide());
                if (selected.attr('balance') !== '' && selected.attr('balance') !== '0') {
                    $('#balanceInfo').show();
                    $('#balanceInfo').html('Balance: PKR ' + selected.attr('balance'));
                } else {
                    $('#balanceInfo').hide();
                }
                if ($(this).val() !== '') {
                    getDiseases();
                }
            }).trigger('change');
        }, 'json');
    }
    function displayReportAttachements() {
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th class="center" width="10%">').html('Sr. #'),
                $('<th class="center" width="60%">').html('Description'),
                $('<th class="center" width="20%">').html('Attachment'),
                $('<th class="center" width="10%">').html('&nbsp;')
                )));
        $.get('setup.htm?action=getReportActtachementsById', {doctorId: $('#doctorId').val(), patientId: $('#patientId').val()},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        for (var i = 0; i < list.length; i++) {
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td align="center">').html(eval(i + 1)),
                                    $('<td>').html(list[i].FILE_DESC),
                                    $('<td align="center">').html('<a href="upload/patient/prescription/' + list[i].TW_PATIENT_ID + '/' + list[i].FILE_NME + '" target="_blank"><img src="images/attach-icon.png" width="20" height="20"></a>'),
                                    $('<td align="center">').html('<i class="fa fa-trash-o" aria-hidden="true" title="Click to Delete" style="cursor: pointer;" onclick="deleteReportAttachement(\'' + list[i].TW_PATIENT_ATTACHMENT_ID + '\');"></i>')
                                    ));
                        }
                        $('#reportDiv').html('');
                        $('#reportDiv').append($tbl);
                    } else {
                        $('#reportDiv').html('');
                        $tbl.append(
                                $('<tr>').append(
                                $('<td  colspan="4">').html('<b>No data found.</b>')
                                ));
                        $('#reportDiv').append($tbl);
                    }
                }, 'json');
    }
    function deleteReportAttachement(attachmentId) {
        bootbox.confirm({
            message: "Do you want to delete record?",
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-success'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if (result) {
                    $.post('setup.htm?action=deleteReportAttachement', {attachmentId: attachmentId}, function (res) {
                        if (res.result === 'save_success') {
                            $.bootstrapGrowl("Record deleted successfully.", {
                                ele: 'body',
                                type: 'success',
                                offset: {from: 'top', amount: 80},
                                align: 'right',
                                allow_dismiss: true,
                                stackup_spacing: 10
                            });
                            displayReportAttachements();
                        } else {
                            $.bootstrapGrowl("Record can not be deleted.", {
                                ele: 'body',
                                type: 'danger',
                                offset: {from: 'top', amount: 80},
                                align: 'right',
                                allow_dismiss: true,
                                stackup_spacing: 10
                            });
                        }
                    }, 'json');
                }
            }
        });
    }
    function printPrescription(masterId) {
        document.getElementById("prescForm").action = 'performa.htm?action=printPrescription&id=' + masterId;
        document.getElementById("prescForm").target = '_blank';
        document.getElementById("prescForm").submit();
    }
</script>
<div class="page-head">
    <!-- BEGIN PAGE TITLE -->
    <div class="page-title">
        <h1>Prescription</h1>
    </div>
</div>
<div class="modal fade" id="inTakeForm">
    <div class="modal-dialog  modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">In Take Form</h3>
            </div>
            <div class="modal-body">
                <div class="portlet box green">
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Patient Name</label>
                                    <div>
                                        <input type="text" class="form-control" id="patientName" placeholder="Patient Name" readonly="" >
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Contact No.</label>
                                    <div>
                                        <input type="text" class="form-control" id="contactNo" placeholder="Contact No." onkeyup="onlyInteger(this);" maxlength="11" readonly="">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>City</label>
                                    <div>
                                        <input type="text" class="form-control" id="cityId" readonly="">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Address</label>
                                    <div>
                                        <input type="text" class="form-control" id="address" readonly="" >
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Referred By</label>
                                    <div>
                                        <input type="text" class="form-control"id="referredBy" readonly="" >
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="portlet box green">
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Attending any clinic?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="attendClinic" value="Y" class="icheck"> Yes </label>
                                            <label>
                                                <input type="radio" name="attendClinic" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Taking any medicine?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="medicineOpt" value="Y" class="icheck" > Yes </label>
                                            <label>
                                                <input type="radio" name="medicineOpt" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Taking any steroid?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="steroidOpt" value="Y" class="icheck"> Yes </label>
                                            <label>
                                                <input type="radio" name="steroidOpt" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Allergy from any medicine/food?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="allergy" value="Y" class="icheck"> Yes </label>
                                            <label>
                                                <input type="radio" name="allergy" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Have any Rheumatic fever or cholera?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="Rheumatic" value="Y" class="icheck"> Yes </label>
                                            <label>
                                                <input type="radio" name="Rheumatic" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label> Are you smoker?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="smoker" value="Y" class="icheck"> Yes </label>
                                            <label>
                                                <input type="radio" name="smoker" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>   
                </div>
                <!--                <div class="portlet box green">
                                    <div class="portlet-title tabbable-line">
                                        <div class="caption">
                                            Diseases 
                                        </div>
                                    </div>
                                    <div class="portlet-body">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group" id="diseases">
                                                    <table class="table table-condensed" width="100%">
                                                        <tbody>
                <c:forEach items="${requestScope.refData.diseases}" var="obj" varStatus="i">
                    <c:if test="${i.count==1}">
                        <tr>
                    </c:if>
                    <td>
                        <input type="checkbox" name="patientDiseases" class="icheck"  value="${obj.TW_DISEASE_ID}">${obj.TITLE}
                    </td>
                    <c:if test="${i.count%4==0}">
                    </tr>
                    <tr>
                    </c:if>
                </c:forEach>
        </tbody>
    </table>
</div>
</div>
</div> 
</div>
</div>-->

                <div class="portlet box green">
                    <div class="portlet-title tabbable-line">
                        <div class="caption">
                            Prescription History 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group" id="prescriptionDiv">

                                </div>
                            </div>
                        </div> 
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="viewPatientModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Patient Info</h3>
            </div>
            <div class="modal-body">
                <!--                <div class="portlet box green">
                                    <div class="portlet-body">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <div class="form-group">
                                                    <label>Patient Name</label>
                                                    <div>
                                                        <input type="text" class="form-control" id="patientName" placeholder="Patient Name" readonly="" >
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Contact No.</label>
                                                    <div>
                                                        <input type="text" class="form-control" id="contactNo" placeholder="Contact No." onkeyup="onlyInteger(this);" maxlength="11" readonly="">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>-->
                <div class="portlet box green">
                    <div class="portlet-title tabbable-line">
                        <div class="caption">
                            Attachments 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <table class="table table-striped table-condensed" id="displayPatientAttachTbl">
                            <thead>
                                <tr>
                                    <th>Sr#</th>
                                    <th>File</th>
                                    <th>Description</th>
                                    <th>&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="attachModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Attach Report</h3>
            </div>
            <div class="modal-body">
                <div id="reportDiv">

                </div>
                <div class="portlet box green">
                    <div class="portlet-title tabbable-line">
                        <div class="caption">
                            Attach Report
                        </div>
                    </div>
                    <div class="portlet-body">
                        <form action="#" id="reportAttachmentFrom" >
                            <input type="hidden" name="attachmentType" value="prescription" />
                            <div class="row">
                                <div class="col-md-4 form-group">
                                    <label>Select Report</label>
                                    <input name="report" class="form-control" type="file">
                                </div>
                                <div class="col-md-5 form-group">
                                    <label>Description</label>
                                    <input class="form-control" name="reportDesc">
                                </div>
                                <div class="col-md-3 form-group">
                                    <br/>
                                    <button type="button" class="btn btn-primary" onclick="saveReports();"><i class="fa fa-upload"></i> Upload</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="portlet box green">
            <div class="portlet-title tabbable-line">
                <div class="caption">
                    Patient Info 
                </div>
            </div>
            <div class="portlet-body">
                <form action="#" role="form" method="post" id="prescForm">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <label class="control-label">Patient</label>
                                        <select class=" form-control" name="patientId" id="patientId" data-placeholder="Choose a Patient" tabindex="1">

                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div style="padding-top: 20px;">
                                        <div class="btn-group btn-group-solid">
                                            <!--<button type="button" class="btn green" onclick="viewPatientInfo();"><span class="md-click-circle md-click-animate" ></span><i class="fa fa-user"></i></button>-->
                                            <button type="button" class="btn blue" onclick="viewInTakeForm(); viewPatientInfo(); getPrescription();"><span class="md-click-circle md-click-animate" ></span><i class="fa fa-bullhorn"></i></button>
                                            <button type="button" class="btn red" onclick="attachReport();"><span class="md-click-circle md-click-animate" ></span><i class="fa fa-upload"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <label >Remarks</label>
                                    <textarea class="form-control" id="comments" name="comments" rows="3" cols="30"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="alert alert-success" id="panelPatient" role="alert">
                                <i class="fa fa-check-circle"></i> Panel Patient
                            </div>
                            <div class="alert alert-warning" id="balanceInfo" role="alert">
                                Balance: 0
                            </div>
                            <div class="panel panel-danger border">
                                <div class="panel-heading">
                                    <div class="panel-title">
                                        <h4>Primary Diagnostics</h4>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div  id="diseaseDiv">

                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="portlet box red">
            <div class="portlet-title tabbable-line">
                <div class="caption">
                    Medicine
                </div>
            </div>
            <div class="portlet-body">
                <form action="#" role="form" method="post">
                    <table class="table" id="medicineTable">
                        <thead>
                            <tr>
                                <th width="30%">
                                    Medicine
                                </th>
                                <th width="5%">
                                    Days
                                </th>
                                <th width="5%">
                                    Qty
                                </th>
                                <th width="20%">
                                    Frequency
                                </th>
                                <th width="20%">
                                    Instructions
                                </th>
                                <th width="10%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <select  class="form-control select2_category" name="medicineId">
                                        <option value="">Select Medicine</option>
                                        <c:forEach items="${requestScope.refData.medicines}" var="obj">
                                            <option value="${obj.TW_MEDICINE_ID}">${obj.PRODUCT_NME}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="medicineDays" class="form-control input-sm" value="1" onkeyup="onlyInteger(this);">
                                </td>
                                <td>
                                    <input type="text" name="medicineQty" class="form-control input-sm" value="1" onkeyup="onlyInteger(this);">
                                </td>
                                <td>
                                    <select class="select2_category form-control" name="medicineFrequency">
                                        <c:forEach items="${requestScope.refData.frequencies}" var="obj">
                                            <option value="${obj.TW_FREQUENCY_ID}">${obj.TITLE}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select class="select2_category form-control" name="medicineInstructions">
                                        <c:forEach items="${requestScope.refData.doseUsage}" var="obj">
                                            <option value="${obj.TW_DOSE_USAGE_ID}">${obj.TITLE}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm green" onclick="addRow(this);" >
                                        <i class="fa fa-plus-circle" aria-hidden="true"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                </form>
            </div>
        </div>

        <div class="portlet box blue">
            <div class="portlet-title tabbable-line">
                <div class="caption">
                    Lab Test
                </div>
            </div>
            <div class="portlet-body">
                <form action="#" role="form" method="post">
                    <table class="table" id="testTable">
                        <thead>
                            <tr>
                                <th width="25%">
                                    Test Name
                                </th>
                                <th colspan="2" width="55%">
                                    Recommended Lab
                                </th>
                                <th width="10%">
                                    Occurrence
                                </th>
                                <th width="10%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <select  class="form-control select2_category" name="labTestId">
                                        <option value="">No Lab Test</option>
                                        <c:forEach items="${requestScope.refData.labTests}" var="obj">
                                            <option value="${obj.TW_LAB_TEST_ID}">${obj.TITLE}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select  class="form-control select2_category" name="labId" onchange="getCollectionCenter(this);">
                                        <option value="">Please select lab</option>
                                        <c:forEach items="${requestScope.refData.labs}" var="obj">
                                            <option value="${obj.TW_LAB_MASTER_ID}">${obj.LAB_NME}</option>
                                        </c:forEach>
                                    </select>
                                    <!--                                    <select  class="form-control select2_category" name="labId">
                                                                            <option value="">Please select lab</option>
                                    <c:forEach items="${requestScope.refData.medicalLabs}" var="obj">
                                        <option value="${obj.TW_LABORATORY_ID}">${obj.LABORATORY_NME}</option>
                                    </c:forEach>
                                </select>-->
                                </td>
                                <td>
                                    <select  class="form-control select2_category" class="collectionCenterId" name="collectionCenterId">
                                        <option value="">Please select center</option>
                                    </select>
                                </td>
                                <td>
                                    <input class="form-control input-sm" name="occurrence" class="occurrence" />
                                </td>
                                <td align="right">
                                    <button type="button" class="btn btn-sm green" onclick="addLabTestRow(this);" >
                                        <i class="fa fa-plus-circle" aria-hidden="true"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <button type="button" onclick="saveData();" class="btn blue"><i class="fa fa-floppy-o"></i> Save</button>
            </div>
        </div> 
    </div>
</div>
<%@include file="../footer.jsp"%>