"object"!=typeof JSON&&(JSON={}),function(){"use strict";function f(t){return t<10?"0"+t:t}function this_value(){return this.valueOf()}var cx,escapable,gap,indent,meta,rep;function quote(t){return escapable.lastIndex=0,escapable.test(t)?'"'+t.replace(escapable,function(t){var e=meta[t];return"string"==typeof e?e:"\\u"+("0000"+t.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+t+'"'}function str(t,e){var n,r,o,u,f,i=gap,a=e[t];switch(a&&"object"==typeof a&&"function"==typeof a.toJSON&&(a=a.toJSON(t)),"function"==typeof rep&&(a=rep.call(e,t,a)),typeof a){case"string":return quote(a);case"number":return isFinite(a)?String(a):"null";case"boolean":case"null":return String(a);case"object":if(!a)return"null";if(gap+=indent,f=[],"[object Array]"===Object.prototype.toString.apply(a)){for(u=a.length,n=0;n<u;n+=1)f[n]=str(n,a)||"null";return o=0===f.length?"[]":gap?"[\n"+gap+f.join(",\n"+gap)+"\n"+i+"]":"["+f.join(",")+"]",gap=i,o}if(rep&&"object"==typeof rep)for(u=rep.length,n=0;n<u;n+=1)"string"==typeof rep[n]&&(o=str(r=rep[n],a))&&f.push(quote(r)+(gap?": ":":")+o);else for(r in a)Object.prototype.hasOwnProperty.call(a,r)&&(o=str(r,a))&&f.push(quote(r)+(gap?": ":":")+o);return o=0===f.length?"{}":gap?"{\n"+gap+f.join(",\n"+gap)+"\n"+i+"}":"{"+f.join(",")+"}",gap=i,o}}"function"!=typeof Date.prototype.toJSON&&(Date.prototype.toJSON=function(){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+f(this.getUTCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z":null},Boolean.prototype.toJSON=this_value,Number.prototype.toJSON=this_value,String.prototype.toJSON=this_value),"function"!=typeof JSON.stringify&&(escapable=/[\\\"\u0000-\u001f\u007f-\u009f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,meta={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},JSON.stringify=function(t,e,n){var r;if(gap="",indent="","number"==typeof n)for(r=0;r<n;r+=1)indent+=" ";else"string"==typeof n&&(indent=n);if(rep=e,e&&"function"!=typeof e&&("object"!=typeof e||"number"!=typeof e.length))throw new Error("JSON.stringify");return str("",{"":t})}),"function"!=typeof JSON.parse&&(cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,JSON.parse=function(text,reviver){var j;function walk(t,e){var n,r,o=t[e];if(o&&"object"==typeof o)for(n in o)Object.prototype.hasOwnProperty.call(o,n)&&(void 0!==(r=walk(o,n))?o[n]=r:delete o[n]);return reviver.call(t,e,o)}if(text=String(text),cx.lastIndex=0,cx.test(text)&&(text=text.replace(cx,function(t){return"\\u"+("0000"+t.charCodeAt(0).toString(16)).slice(-4)})),/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return j=eval("("+text+")"),"function"==typeof reviver?walk({"":j},""):j;throw new SyntaxError("JSON.parse")})}();

var selectedAppIconArtboards = {};
var selectedAppIconExportOptions = {};

var selectedImagesArtboards = {};
var selectedImageExportOptions = {};

var iosAppIconExportOptions = [
    {
        name: "-20@2x.png",
        size: 40,
        type: "Notification for iPhone with retina display (2x)",
        idiom: "iphone",
        sizeJSON: "20x20",
        scale: "2x"
    },
    {
        name: "-20@3x.png",
        size: 60,
        type: "Notification for iPhone with retina display (3x)",
        idiom: "iphone",
        sizeJSON: "20x20",
        scale: "3x"
    },
    {
        name: "-29@2x.png",
        size: 58,
        type: "Spotlight iOS 5,6; Settings iOS 5 - 11",
        idiom: "iphone",
        sizeJSON: "29x29",
        scale: "2x"
    },
    {
        name: "-29@3x.png",
        size: 87,
        type: "Spotlight iOS 5,6; Settings iOS 5 - 11",
        idiom: "iphone",
        sizeJSON: "29x29",
        scale: "3x"
    },
    {
        name: "-60@2x.png",
        size: 120,
        type: "Home screen on iPhone/iPod Touch with retina display",
        idiom: "iphone",
        sizeJSON: "60x60",
        scale: "2x"
    },
    {
        name: "-60@3x.png",
        size: 180,
        type: "Home screen on iPhone 6 Plus",
        idiom: "iphone",
        sizeJSON: "60x60",
        scale: "3x"
    },
    {
        name: "-iPad-29.png",
        size: 29,
        type: "settings on iPad for iOS 5 - 11",
        idiom: "ipad",
        sizeJSON: "29x29",
        scale: "1x"
    },
    {
        name: "-iPad-29@2x.png",
        size: 58,
        type: "settings on iPad with retina display for iOS 5 - 11",
        idiom: "ipad",
        sizeJSON: "29x29",
        scale: "2x"
    },
    {
        name: "-76.png",
        size: 76,
        type: "Home screen on iPad",
        idiom: "ipad",
        sizeJSON: "76x76",
        scale: "1x"
    },
    {
        name: "-76@2x.png",
        size: 152,
        type: "Home screen on iPad with retina display",
        idiom: "ipad",
        sizeJSON: "76x76",
        scale: "2x"
    },
    //{
    //     name: "-Small-40.png",
    //     size: 40,
    //     type: "Spotlight",
    //     idiom: "iphone",
    //     sizeJSON: "40x40",
    //     scale: "1x"
    // },
    {
        name: "-Small-40@2x.png",
        size: 80,
        type: "Spotlight on devices with retina display",
        idiom: "iphone",
        sizeJSON: "40x40",
        scale: "2x"
    },
    {
        name: "-Small-40@3x.png",
        size: 120,
        type: "Spotlight on iPhone 6 Plus",
        idiom: "iphone",
        sizeJSON: "40x40",
        scale: "3x"
    },
    {
        name: "-40.png",
        size: 40,
        type: "Spotlight for iPad",
        idiom: "ipad",
        sizeJSON: "40x40",
        scale: "1x"
    },
    {
        name: "-40@2x.png",
        size: 80,
        type: "Spotlight for iPad with retina display",
        idiom: "ipad",
        sizeJSON: "40x40",
        scale: "2x"
    },
    {
        name: "-20.png",
        size: 20,
        type: "Notification for iPad",
        idiom: "ipad",
        sizeJSON: "20x20",
        scale: "1x"
    },
    {
        name: "-iPad-20@2x.png",
        size: 40,
        type: "Notification for iPad with retina display",
        idiom: "ipad",
        sizeJSON: "20x20",
        scale: "2x"
    },
    {
        name: "-iPad-835@2x.png",
        size: 167,
        type: "Home screen on iPad Pro",
        idiom: "ipad",
        sizeJSON: "83.5x83.5",
        scale: "2x"
    },
    {
        name: "-Artwork.png",
        size: 1024,
        type: "Icon on App Store",
        idiom: "ios-marketing",
        sizeJSON: "1024x1024",
        scale: "1x"
    }
];

var iosImageExportOptions = [
    {
        name: "",
        scaleFactor: 100,
        type: "1x"
    },
    {
        name: "@2x",
        scaleFactor: 200,
        type: "2x"
    },
    {
        name: "@3x",
        scaleFactor: 300,
        type: "3x"
    }
];

var folder = Folder.selectDialog("Select export directory");
var document = app.activeDocument;

if (document && folder) {
    var dialog = new Window("dialog", "Export assets for iOS");

    var appIconGroup = dialog.add("group");
    appIconGroup.alignChildren = "top";
    createArtboardSelectionPanel("Select artboards to export as App Icons", selectedAppIconArtboards, appIconGroup);
    createSelectionPanel("Export options for App Icon", iosAppIconExportOptions, selectedAppIconExportOptions, appIconGroup);

    var imageGroup = dialog.add("group");
    imageGroup.alignChildren = "top";
    createArtboardSelectionPanel("Select artboards to export as images", selectedImagesArtboards, imageGroup);
    createSelectionPanel("Export options for Images", iosImageExportOptions, selectedImageExportOptions, imageGroup);

    var buttonGroup = dialog.add("group");
    var okButton = buttonGroup.add("button", undefined, "Export");
    var cancelButton = buttonGroup.add("button", undefined, "Cancel");

    okButton.onClick = function () {
        exportAppIcons();
        exportImages();

        this.parent.parent.close();
    };

    cancelButton.onClick = function () {
        this.parent.parent.close();
    };

    dialog.show();
}

function exportAppIcons() {
    for (var artboardName in selectedAppIconArtboards) {
        var artboard = app.activeDocument.artboards.getByName(artboardName);
        var activeIndex = 0;
        while (!(app.activeDocument.artboards[activeIndex].name === artboardName)) {
            activeIndex++;
        }
        app.activeDocument.artboards.setActiveArtboardIndex(activeIndex);


        var expFolder = new Folder(folder.fsName + "/" + artboard.name + ".appiconset" + "/");
        if (!expFolder.exists) {
            expFolder.create();
        }

        var jsonFileObject = {
            images: [],
            info: {
                version: 1,
                author: "xcode"
            }
        };

        for (var key in selectedAppIconExportOptions) {
            var item = selectedAppIconExportOptions[key];
            jsonFileObject.images.push({
                idiom: item.idiom,
                size: item.sizeJSON,
                filename: artboard.name + item.name,
                scale: item.scale
            });
        }

        var jsonFile = new File(expFolder.fsName + "/Contents.json");
        jsonFile.open("w");
        jsonFile.write(JSON.stringify(jsonFileObject, null, 2));
        jsonFile.close();

        for (var key in selectedAppIconExportOptions) {
            var item = selectedAppIconExportOptions[key];
            exportAppIcon(artboard, expFolder, artboard.name + item.name, item.size, item.type);
        }
    }
};

function exportAppIcon(artboard, expFolder, name, iconSize, type) {
    var scale = iconSize * 100 / Math.abs(artboard.artboardRect[1] - artboard.artboardRect[3]);

    if (app.documents.length > 0) {
        var exportOptions = new ExportOptionsPNG24();
        var type = ExportType.PNG24;
        var fileSpec = new File(expFolder.fsName + "/" + name);
        exportOptions.verticalScale = scale;
        exportOptions.horizontalScale = scale;
        exportOptions.antiAliasing = false;
        exportOptions.transparency = true;
        exportOptions.artBoardClipping = true;
        app.activeDocument.exportFile(fileSpec, type, exportOptions);
    }
};

function exportImages() {
    for (var artboardName in selectedImagesArtboards) {
        var activeArtboard = app.activeDocument.artboards.getByName(artboardName);
        var activeIndex = 0;
        while (!(app.activeDocument.artboards[activeIndex].name === artboardName)) {
            activeIndex++;
        }
        app.activeDocument.artboards.setActiveArtboardIndex(activeIndex);

        var expFolder = new Folder(folder.fsName + "/" + activeArtboard.name + ".imageset" + "/");
        if (!expFolder.exists) {
            expFolder.create();
        }

        var jsonFileObject = {
            images: [],
            info: {
                version: 1,
                author: "xcode"
            }
        };

        for (var key in selectedImageExportOptions) {
            var item = selectedImageExportOptions[key];
            jsonFileObject.images.push({
                idiom: "universal",
                scale: item.type,
                filename: activeArtboard.name + item.name + ".png"
            });
        }

        var jsonFile = new File(expFolder.fsName + "/Contents.json");
        jsonFile.open("w");
        jsonFile.write(JSON.stringify(jsonFileObject, null, 2));
        jsonFile.close();

        for (var key in selectedImageExportOptions) {
            if (selectedImageExportOptions.hasOwnProperty(key)) {
                var item = selectedImageExportOptions[key];
                exportImage(expFolder, activeArtboard, item.name, item.scaleFactor, item.type)
            }
        }
    }
};

function exportImage(expFolder, activeArtboard, name, scale, type) {
    var exportOptions = new ExportOptionsPNG24();
    var type = ExportType.PNG24;
    var fileSpec = new File(expFolder.fsName + "/" + activeArtboard.name + name + ".png");
    exportOptions.verticalScale = scale;
    exportOptions.horizontalScale = scale;
    exportOptions.antiAliasing = true;
    exportOptions.transparency = true;
    exportOptions.artBoardClipping = true;
    app.activeDocument.exportFile(fileSpec, type, exportOptions);
};

function createArtboardSelectionPanel(name, selected, parent) {
    var panel = parent.add("panel", undefined, name);
    panel.alignChildren = "left";
    panel.minimumSize.width = 300;
    panel.orientation = "row";
    panel.alignChildren = "top";

    var CHECKBOXES_PER_PANEL = 10;
    var totalPanels = Math.ceil(app.activeDocument.artboards.length / CHECKBOXES_PER_PANEL);
    var groups = []
    for (var i = 0; i < totalPanels; i++) {
        var group = panel.add("group", undefined, name);
        group.orientation = "column";
        group.alignChildren = "left";
        groups.push(group);
    }
    ;

    for (var i = 0; i < app.activeDocument.artboards.length; i++) {
        var destGroup = groups[Math.floor(i / CHECKBOXES_PER_PANEL)];

        var cb = destGroup.add("checkbox", undefined, "\u00A0" + app.activeDocument.artboards[i].name)
        cb.item = app.activeDocument.artboards[i];
        cb.value = false;
        cb.onClick = function () {
            if (this.value) {
                selected[this.item.name] = this.item;
            } else {
                delete selected[this.item.name];
            }
        };
    }
};

function createSelectionPanel(name, array, selected, parent) {
    var panel = parent.add("panel", undefined, name);
    panel.alignChildren = "left";
    panel.minimumSize.width = 400;
    for (var i = 0; i < array.length; i++) {
        var cb = panel.add("checkbox", undefined, "\u00A0" + array[i].type);
        cb.item = array[i];
        cb.value = true;
        cb.onClick = function () {
            if (this.value) {
                selected[this.item.name] = this.item;
                //alert("added " + this.item.name);
            } else {
                delete selected[this.item.name];
                //alert("deleted " + this.item.name);
            }
        };
        selected[array[i].name] = array[i];
    }
};
