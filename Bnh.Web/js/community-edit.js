﻿define(
    ["jquery", "map-editor", "json", "tinymce"],
    function ($, MapEditor) {
        "use strict"

        var gpsLocationField = $("#GpsLocation");
        var gpsBoundsField = $("#GpsBounds");

        var overlays = {
            marker: gpsLocationField.val() ? JSON.parse(gpsLocationField.val()) : null,
            polygon: gpsBoundsField.val() ? JSON.parse(gpsBoundsField.val()) : null,
            zoom: 14
        };

        var mapEditor = new MapEditor("#mapCanvas", overlays);

        // handle onsubmit event to gather gps coordiates from map
        $("input:submit, button:submit").click(function () {
            gpsLocationField.val(JSON.stringify(mapEditor.getLocation()));
            gpsBoundsField.val(JSON.stringify(mapEditor.getBounds()));
        });

        tinymce.init({
            mode: "textareas",
            pugins: "emotions,spellchecker,advhr,insertdatetime,preview",
            theme: "advanced",

            plugins: "autolink,lists,spellchecker,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",

            // Theme options
            theme_advanced_buttons1: "newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
            theme_advanced_buttons2: "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
            theme_advanced_buttons3: "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
            theme_advanced_buttons4: "insertlayer,moveforward,movebackward,absolute,|,styleprops,spellchecker,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,blockquote,pagebreak,|,insertfile,insertimage",
            theme_advanced_toolbar_location: "top",
            theme_advanced_toolbar_align: "left",
            theme_advanced_statusbar_location: "bottom",
            theme_advanced_resizing: true,

            /*forced_root_block: false,*/

            // Skin options
            skin: "o2k7",
            skin_variant: "silver"
        });
    }
);