{ pkgs, ... }:
{
  home.packages = [
    pkgs.calibre
  ];

  xdg = {
    desktopEntries = {
      calibre-gui = {
        name= "Calibre";
        type = "Application";
        genericName = "E-book library management";
        comment = "E-book library management: Convert, view, share, catalogue all your e-books";
        # tryExec = "calibre";
        exec = "calibre --detach %U";
        icon = "calibre-gui";
        categories = [
          "Office"
        ];
        # keywords = [
        #   "epub"
        #   "ebook"
        #   "manager"
        # ];
        mimeType = [
          "application/xhtml+xml"
          "text/html"
          "image/vnd.djvu"
          "application/x-mobipocket-subscription"
          "application/x-cbc"
          "application/vnd.ms-word.document.macroenabled.12"
          "application/x-cb7"
          "application/x-mobi8-ebook"
          "text/fb2+xml"
          "application/oebps-package+xml"
          "text/rtf"
          "text/plain"
          "application/x-sony-bbeb"
          "text/x-markdown"
          "application/pdf"
          "application/x-cbz"
          "application/x-mobipocket-ebook"
          "application/ereader"
          "application/epub+zip"
          "application/vnd.oasis.opendocument.text"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          "application/x-cbr"
          "x-scheme-handler/calibre"
        ];
      };

      calibre-ebook-viewer = {
        name= "E-book Viewer";
        type = "Application";
        genericName = "Viewer of E-books";
        comment = "Viewer for E-books in all the major formats";
        # tryExec = "ebook-viewer";
        exec = "ebook-viewer --detach %f";
        icon = "calibre-viewer";
        categories = [
          "Office"
          "Viewer"
        ];
        # keywords = [
        #   "epub"
        #   "ebook"
        #   "viewer"
        # ];
        mimeType = [
          "application/xhtml+xml"
          "text/html"
          "image/vnd.djvu"
          "application/x-mobipocket-subscription"
          "application/x-cbc"
          "application/vnd.ms-word.document.macroenabled.12"
          "application/x-cb7"
          "application/x-mobi8-ebook"
          "text/fb2+xml"
          "application/oebps-package+xml"
          "text/rtf"
          "text/plain"
          "application/x-sony-bbeb"
          "text/x-markdown"
          "application/pdf"
          "application/x-cbz"
          "application/x-mobipocket-ebook"
          "application/ereader"
          "application/epub+zip"
          "application/vnd.oasis.opendocument.text"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          "application/x-cbr"
        ];
      };

      calibre-lrfviewer = {
        name = "LRF Viewer";
        exec = "lrfviewer %f";
        noDisplay = true;
      };

      calibre-ebook-edit = {
        name = "E-book Editor";
        exec = "ebook-edit --detach %f";
        noDisplay = true;
      };

    };

    mimeApps.defaultApplications = {
        "application/lrf" = "calibre-lrfviewer.desktop";
    };
  };
}
