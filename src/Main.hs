module Main where

import Graphics.UI.Gtk
import Graphics.UI.Gtk.Builder
import System.Process (createProcess, proc, waitForProcess)
import System.Posix.Files (createSymbolicLink)
import Control.Monad (foldM_)
import System.Directory (doesDirectoryExist, removeDirectoryRecursive, createDirectoryIfMissing)

addFileToSelectionList window listModel = do
    dialog <- fileChooserDialogNew Nothing (Just window) FileChooserActionOpen [
        ("Cancel", ResponseCancel),
        ("Add", ResponseAccept)
        ]
    fileChooserSetSelectMultiple dialog True
    widgetShow dialog
    response <- dialogRun dialog

    case response of
          ResponseCancel -> return ()
          ResponseAccept -> do newFiles <- fileChooserGetFilenames dialog
                               mapM_ (listStoreAppend listModel) newFiles
    widgetDestroy dialog
    return ()

initializeFileList :: Builder -> IO (ListStore String)
initializeFileList builder = do
    fileList <- listStoreNew []
    col <- treeViewColumnNew
    treeViewColumnSetTitle col "Images"
    renderer <- cellRendererTextNew
    cellLayoutPackStart col renderer False
    cellLayoutSetAttributes col renderer fileList (\c -> [cellText := c])
    fileListTreeView <- builderGetObject builder castToTreeView "fileListing"
    treeViewAppendColumn fileListTreeView col
    treeViewSetModel fileListTreeView fileList
    treeViewSetHeadersVisible fileListTreeView True
    return fileList

-- Creates a numbered symlink of the given file
tmpSymlink i fName = do
    createSymbolicLink fName ("/tmp/timelapse/" ++ (show i ) ++ ".jpg")
    return (i + 1)

removeAndRecreate path = do
    dirThere <- doesDirectoryExist path
    if dirThere
        then removeDirectoryRecursive path
        else return ()
    createDirectoryIfMissing False path

createTimelapseFrom :: ListStore FilePath -> IO ()
createTimelapseFrom fileListStore = do
    files <- listStoreToList fileListStore
    --Create symlinks to get sequenced numbers
    removeAndRecreate "/tmp/timelapse"
    foldM_ tmpSymlink 0 files
    (_, _, _, pHandle) <- createProcess (proc "xterm" ["-hold", "-title", "timelapse encoding to /tmp/timelapse.ogg", "-e",
        "gst-launch-0.10",
        "multifilesrc", "location=\"/tmp/timelapse/%d.jpg\"", "caps=\"image/jpeg,framerate=25/1\"",
        " ! ", "jpegdec",
        " ! ", "videorate",
        " ! ", "theoraenc", "drop-frames=false",
        " ! ", "progressreport",
        " ! ", "oggmux",
        " ! ", "filesink",  "location=\"/tmp/timelapse.ogg\""
        ])
    waitForProcess pHandle
    mainQuit


main :: IO()
main = do
    initGUI
    builder <- builderNew
    builderAddFromFile builder "main.glade"
    addFileButton <- builderGetObject builder castToButton "addFileButton"
    executeButton <- builderGetObject builder castToButton "executeButton"
    mainWindow <- builderGetObject builder castToWindow "mainWindow"
    fileList <- initializeFileList builder

    onClicked addFileButton (addFileToSelectionList mainWindow fileList)
    onClicked executeButton (createTimelapseFrom fileList)

    on mainWindow objectDestroy mainQuit
    widgetShowAll mainWindow
    mainGUI
