<%-- 
    Document   : addPharmacyStore
    Created on : Jan 19, 2018, 6:37:39 PM
    Author     : dell
--%>

<%@include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="assets/global/plugins/bootstrap-timepicker/css/bootstrap-timepicker.min.css"/>
<script type="text/javascript" src="assets/global/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
<script type="text/javascript" src="assets/global/plugins/jquery-inputmask/jquery.inputmask.bundle.min.js"></script>
<script>
    $(function () {
        $('#pharmaId').select2({
            placeholder: "Select an option",
            allowClear: true
        });
        $('#cityId').select2({
            placeholder: "Select an option",
            allowClear: true
        });
        $('#areaId').select2({
            placeholder: "Select an option",
            allowClear: true
        });
        $("#cellNo").inputmask("mask", {
            "mask": "99999999999"
        });
        $("#ptclNo").inputmask("mask", {
            "mask": "99999999999"
        });
        $('#cityId').change(function () {
            getCityArea();
        }).trigger('change');
        $('#pharmaId').change(function () {
            displayData();
        }).trigger('change');
        $('#timeFrom').timepicker({minuteStep: 5, showMeridian: false});
        $('#timeTo').timepicker({minuteStep: 5, showMeridian: false});
        
    });
    function getCityArea() {
        //Find all areas
        $('#areaId').find('option').remove();
        if ($('#cityId').val() !== '') {
            $.get('clinic.htm?action=getAreasByCityId', {cityId: $('#cityId').val()}, function (data) {
                if (data !== null && data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        $('<option />', {value: data[i].CITY_AREA_ID, text: data[i].AREA_NME}).appendTo($('#areaId'));
                    }
                } else {
                    $('<option />', {value: '', text: 'No Area Found'}).appendTo($('#areaId'));
                }
                if ($('#editArea').val() !== '') {
                    $('#areaId').val($('#editArea').val()).trigger('change');
                    $('#editArea').val('');
                } else {
                    $('#areaId').trigger('change');
                }
            }, 'json');
        }
    }
    function displayData() {
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th class="center" width="5%">').html('Sr. #'),
                $('<th class="center" width="30%">').html('Store Name'),
                $('<th class="center" width="25%">').html('Contact Person'),
                $('<th class="center" width="10%">').html('Cell No'),
                $('<th class="center" width="10%">').html('City'),
                $('<th class="center" width="10%">').html('Area'),
                $('<th class="center" width="10%" colspan="2">').html('&nbsp;')
                )));
        $.get('performa.htm?action=getPharmacyStore', {pharmaId:$('#pharmaId').val()},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        for (var i = 0; i < list.length; i++) {
                            var editHtm = '<i class="fa fa-pencil-square-o" aria-hidden="true" title="Click to Edit" style="cursor: pointer;" onclick="editRow(\'' + list[i].TW_PHARMACY_STORE_ID + '\');"></i>';
                            var delHtm = '<i class="fa fa-trash-o" aria-hidden="true" title="Click to Delete" style="cursor: pointer;" onclick="deleteRow(\'' + list[i].TW_PHARMACY_STORE_ID + '\');"></i>';
                            if ($('#can_edit').val() !== 'Y') {
                                editHtm = '&nbsp;';
                            }
                            if ($('#can_delete').val() !== 'Y') {
                                delHtm = '&nbsp;';
                            }
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td  align="center">').html(eval(i + 1)),
                                    $('<td>').html(list[i].STORE_NME),
                                    $('<td>').html(list[i].CONTACT_PERSON),
                                    $('<td>').html(list[i].MOBILE_NO),
                                    $('<td>').html(list[i].CITY_NME),
                                    $('<td>').html(list[i].AREA_NME),
                                    $('<td align="center">').html(editHtm),
                                    $('<td  align="center">').html(delHtm)
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
    function addPharmaStore() {
        $('#loginId').val('');
        $('#loginId').attr('readonly',false);
        $('#pharmaStoreId').val('');
        $('#storeName').val('');
        $('#contactPerson').val('');
        $('#cellNo').val('');
        $('#ptclNo').val('');
        $('#email').val('');
        $('#addPharmaStore').modal('show');
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
                    $.post('performa.htm?action=deletePharmacyStore', {id: id}, function (res) {
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
    function editRow(id) {
        $('#pharmaStoreId').val(id);
        $.get('performa.htm?action=getPharmacyStoreById', {id: id},
                function (obj) {
                    $('#storeName').val(obj.STORE_NME);
                    $('#contactPerson').val(obj.CONTACT_PERSON);
                    $('#cellNo').val(obj.MOBILE_NO);
                    $('#ptclNo').val(obj.LANDLINE_NO);
                    $('#email').val(obj.EMAIL);
                    $('#cityId').val(obj.CITY_ID).trigger('change');
                    $('#editArea').val(obj.CITY_AREA_ID);
                    $('#timeFrom').val(obj.OPEN_FRM);
                    $('#timeTo').val(obj.OPEN_TO);
                    $('#loginId').val(obj.USER_NME);
                    $('#loginId').attr('readonly',true);
                    $('#addPharmaStore').modal('show');
                }, 'json');
    }
    function saveStore() {
        if ($.trim($('#storeName').val()) === '') {
            $('#storeName').notify('Store Name is Required Field', 'error', {autoHideDelay: 15000});
            $('#storeName').focus();
            return false;
        }
        if ($.trim($('#contactPerson').val()) === '') {
            $('#contactPerson').notify('Contact Person is Required Field', 'error', {autoHideDelay: 15000});
            $('#contactPerson').focus();
            return false;
        }
        if ($('#cellNo').val() === '') {
            $('#cellNo').notify('Cell No is Required Field', 'error', {autoHideDelay: 15000});
            $('#cellNo').focus();
            return false;
        }
        if ($('#cityId').val() === '') {
            $('#cityId').notify('City Name is Required Field', 'error', {autoHideDelay: 15000});
            $('#cityId').focus();
            return false;
        }
        if ($('#areaId').val() === '') {
            $('#areaId').notify('Area Name is Required Field', 'error', {autoHideDelay: 15000});
            $('#areaId').focus();
            return false;
        }
        if ($('#pharmaStoreId').val() === '') {
            if ($('#loginId').val() === '') {
                $('#loginId').notify('Login Id is Required Field', 'error', {autoHideDelay: 15000});
                $('#loginId').focus();
                return false;
            }
        }
        var data = new FormData(document.getElementById('pharmaStore'));
        data.append('pharmaId', $('#pharmaId').val());
        $.ajax({
            url: 'performa.htm?action=savePharmacyStore',
            type: "POST",
            data: data,
            cache: false,
            dataType: 'json',
            processData: false, // tell jQuery not to process the data
            contentType: false   // tell jQuery not to set contentType

        }).done(function (data) {
            if (data) {
                if (data.result === 'save_success') {
                    $.bootstrapGrowl("Store Save successfully.", {
                        ele: 'body',
                        type: 'success',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10

                    });
                    displayData();
                    $('#addPharmaStore').modal('hide');

                } else {
                    $.bootstrapGrowl("Error in Saving Store.", {
                        ele: 'body',
                        type: 'danger',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10
                    });
                    $('#addPharmaStore').modal('hide');
                }
            }
        });
    }
   
</script>
<input type="hidden" id="editArea" value="">
<input type="hidden" id="can_edit" value="${requestScope.refData.CAN_EDIT}">
<input type="hidden" id="can_delete" value="${requestScope.refData.CAN_DELETE}">
<div class="page-head">
    <!-- BEGIN PAGE TITLE -->
    <div class="page-title">
        <h1>Pharmacy Store</h1>
    </div>
</div>
<div class="modal fade" id="addPharmaStore">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Add Pharmacy Store</h3>
            </div>
            <div class="modal-body">
                <form action="#" role="form" id="pharmaStore" method="post" >
                    <input type="hidden" name="pharmaStoreId" id="pharmaStoreId" value="">
                    <div class="row">                    
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Store Name *</label>
                                <input type="text" class="form-control" id="storeName" name="storeName">
                            </div>
                        </div>
                    </div>
                    <div class="row"> 
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Contact Person *</label>
                                <input type="text" class="form-control" id="contactPerson" name="contactPerson">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Email</label>
                                <input type="text" class="form-control" id="email" name="email">
                            </div>
                        </div>
                    </div>
                    <div class="row"> 
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Cell No. *</label>
                                <input type="text" class="form-control" id="cellNo" name="cellNo">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Land Line No.</label>
                                <input type="text" class="form-control" id="ptclNo" name="ptclNo">
                            </div>
                        </div>
                    </div>
                    <div class="row"> 
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>City *</label>
                                <select id="cityId" name="cityId" class="form-control">
                                    <c:forEach items="${requestScope.refData.cities}" var="city">
                                        <option value="${city.CITY_ID}">${city.CITY_NME}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Area *</label>
                                <select id="areaId" name="areaId" class="form-control">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Time From</label>
                                <div class="input-group bootstrap-timepicker timepicker input-small">
                                    <input id="timeFrom" name="timeFrom" type="text" class="form-control input-small" readonly="">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-time"></i></span>
                                </div>
                            </div>
                        </div> 
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>To</label>
                                <div class="input-group bootstrap-timepicker timepicker input-small">
                                    <input id="timeTo" name="timeTo" type="text" class="form-control input-small" readonly="">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-time"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Login Id *</label>
                                <input id="loginId" name="loginId" type="text" onblur="Util.validatePharmacyStoreLoginId(this);" maxlength="20" class="form-control">
                            </div>
                        </div> 
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="saveStore();">Save</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="portlet-body">
            <div class="portlet box green">
                <div class="portlet-title">
                    <div class="caption">
                        Pharmacy Store
                    </div>
                </div>
                <div class="portlet-body">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Pharmacy Company</label>
                                <select id="pharmaId" class="form-control" onchange="displayData();">
                                    <c:forEach items="${requestScope.refData.companies}" var="obj">
                                        <option value="${obj.TW_PHARMACY_ID}">${obj.PHARMACY_NME}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-right" style="padding-top: 23px; " >
                            <button type="button" class="btn blue" onclick="addPharmaStore();"><i class="fa fa-plus-circle"></i> Add Pharmacy Store</button>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12" style="padding-top: 20px;">
                            <div id="displayDiv">

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            </form>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
