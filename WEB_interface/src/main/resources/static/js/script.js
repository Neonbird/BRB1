function go() {
    console.log("gg");
    let data = new FormData();
    $.each($('#file')[0].files, function (i, file) {
        data.append('file-' + i, file);
    });

    let request = $.ajax({
        url: '/up',
        data: data,
        cache: false,
        contentType: 'multipart/form-data',
        method: 'POST',
        success: function (data) {
            alert(data);
        }
    });
    request.done(function (msg) {
        $("#log").html(msg);
    });

    request.fail(function (jqXHR, textStatus) {
        alert("Request failed: " + textStatus);
    });
}