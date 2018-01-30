<%-- 
    Document   : sendMessage
    Created on : Oct 23, 2017, 7:24:13 PM
    Author     : Cori 5
--%>

<%@include file="../header.jsp"%>
<script>
    $(function () {
        displayData();
    });
    function displayData() {
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th class="center" width="5%">').html('Sr. #'),
                $('<th class="center" width="15%">').html('Subject'),
                $('<th class="center" width="35%">').html('Detail'),
                $('<th class="center" width="15%" colspan="2">').html('&nbsp;')
                )));
        $.get('clinic.htm?action=getMessage', {},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        for (var i = 0; i < list.length; i++) {
                            var sendHtm = '<i class="fa fa-paper-plane" aria-hidden="true" title="Click to Send" style="cursor: pointer;" onclick="displayAppointedPatients(\'' + list[i].TW_SMS_TEMPLATE_ID + '\');"></i>';
//                            var delHtm = '<i class="fa fa-trash-o" aria-hidden="true" title="Click to Delete" style="cursor: pointer;" onclick="deleteRow(\'' + list[i].CITY_ID + '\');"></i>';
                            if ($('#can_edit').val() !== 'Y') {
                                editHtm = '&nbsp;';
                            }
                            if ($('#can_delete').val() !== 'Y') {
                                delHtm = '&nbsp;';
                            }
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td  align="center">').html(eval(i + 1)),
                                    $('<td>').html(list[i].TITLE),
                                    $('<td>').html(list[i].DETAIL),
                                    $('<td align="center">').html(sendHtm)
//                                    $('<td  align="center">').html(delHtm)
                                    ));
                        }
                        $('#displayDiv').html('');
                        $('#displayDiv').append($tbl);
                        return false;
                    } else {
                        $('#displayDiv').html('');
                        $tbl.append(
                                $('<tr>').append(
                                $('<td  colspan="7">').html('<b>No data found.</b>')
                                ));
                        $('#displayDiv').append($tbl);
                        return false;
                    }
                }, 'json');
    }


    function displayAppointedPatients(id) {
        $('#templateId').val(id);
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th class="center" width="20%">').html('Select <input type="checkbox" class="icheck selectAll">'),
                $('<th class="center" width="80%">').html('Patient Name')
                )));
        $.get('clinic.htm?action=getDoctorAppointedPatients', {doctorId: $('#doctorId').val()},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        for (var i = 0; i < list.length; i++) {
                            var check = '';
                            if (i === 0) {
                                check = ' checked="checked"';
                            }
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td  align="center">').html('<input type="checkbox" name="healthCardId" value="' + list[i].TW_APPOINTMENT_ID + '" class="icheck" "' + check + '" >'),
                                    $('<td>').html(list[i].PATIENT_NME)
                                    ));
                        }
                        $('#dvTable').html('');
                        $('#dvTable').append($tbl);
                    } else {
                        $('#dvTable').html('');
                        $tbl.append(
                                $('<tr>').append(
                                $('<td  colspan="2">').html('<b>No data found.</b>')
                                ));
                        $('#dvTable').append($tbl);
                    }
                    $('.icheck').iCheck({
                        checkboxClass: 'icheckbox_square',
                        radioClass: 'iradio_square',
                        increaseArea: '20%' // optional
                    });
                    $('.selectAll').on('ifChecked', function (event) {
                        $('input[name=healthCardId]').iCheck('check');
                    });
                    $('.selectAll').on('ifUnchecked', function (event) {
                        $('input[name=healthCardId]').iCheck('uncheck');
                    });
                    $('#appointedPatients').modal('show');
                }, 'json');
    }


    function saveData() {
        if ($.trim($('#message').val()) === '') {
            $('#message').notify('Message is Required Field', 'error', {autoHideDelay: 15000});
            $('#message').focus();
            return false;
        }
        var obj = {
            message: $('#message').val(),
            subject: $('#subject').val()
        };
        $.post('clinic.htm?action=saveMessage', obj, function (obj) {
            if (obj.result === 'save_success') {
                $.bootstrapGrowl("Message saved successfully.", {
                    ele: 'body',
                    type: 'success',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });
                $('input:text').val('');
                displayData();
                return false;
            } else {
                $.bootstrapGrowl("Error in saving Message. Please try again later.", {
                    ele: 'body',
                    type: 'error',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });

                return false;
            }
        }, 'json');
        return false;
    }

    function deleteRow(id) {
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
                    $.post('clinic.htm?action=deleteCity', {id: id}, function (res) {
                        if (res.result === 'save_success') {
                            $.bootstrapGrowl("Record deleted successfully.", {
                                ele: 'body',
                                type: 'success',
                                offset: {from: 'top', amount: 80},
                                align: 'right',
                                allow_dismiss: true,
                                stackup_spacing: 10
                            });
                            displayData();
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

    function addTemplateDialog() {
        $('#subject').val('');
        $('#message').val('');
        $('#addTemplate').modal('show');
    }

</script>
<div class="page-head">
    <!-- BEGIN PAGE TITLE -->
    <div class="page-title">
        <h1>SMS Template</h1>
    </div>
</div>
<div class="modal fade" id="addTemplate">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Add SMS Template</h3>

            </div>
            <div class="modal-body">
                <input type="hidden" id="diseaseId" value="">
                <form action="#" role="form" method="post" >
                    <div class="row">                            
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Subject</label>                                  
                                <div>
                                    <input type="text" class="form-control" id="subject" placeholder="Subject" >
                                </div>                               
                            </div>
                        </div>
                    </div>
                    <div class="row">                            
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Write a Message</label>
                                <div>
                                    <textarea class="form-control" id="message" placeholder="Write Message" rows="6" cols="30"></textarea>
                                </div>
                            </div>
                        </div>
                        <br/>
                        <br>
                        <br>
                        <br>
                        <br>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="saveData();">Save</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>
<div class="modal fade" id="appointedPatients">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Select Patients</h3>

            </div>
            <div class="modal-body">
                <form action="#" role="form" method="post" >
                    <div class="row">

                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div id="dvTable">
                            </div>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="saveData();">Send Message</button>
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
                    Add SMS Template
                </div>
            </div>
            <div class="portlet-body">
                <input type="hidden" name="Template" id="templateId" value="">
                <input type="hidden" name="doctorId" id="doctorId" value="${requestScope.refData.doctorId}">
                <input type="hidden" id="can_edit" value="${requestScope.refData.CAN_EDIT}">
                <input type="hidden" id="can_delete" value="${requestScope.refData.CAN_DELETE}">
                <form action="#" onsubmit="return false;" role="form" method="post">
                    <div class="row">
                        <div class="col-md-12 text-right" style="padding-top: 23px;">
                            <c:if test="${requestScope.refData.CAN_ADD=='Y'}">
                                <button type="button" class="btn blue" onclick="addTemplateDialog();"><i class="fa fa-plus-circle"></i> New Template</button>
                            </c:if>
                        </div>
                    </div>
                    <br/>
                    <div class="row">
                        <div class="col-md-12">
                            <div id="displayDiv"></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<%@include file="../footer.jsp"%>
