module Main where

import Graphics.UI.Gtk
import Graphics.UI.Gtk.Builder

addFileToSelectionList window listModel = do
    dialog <- fileChooserDialogNew Nothing (Just window) FileChooserActionOpen [("Cancel", ResponseCancel), ("Add", ResponseAccept)]
    fileChooserSetSelectMultiple dialog True
    widgetShow dialog
    response <- dialogRun dialog

    case response of
          ResponseCancel -> return ()
          ResponseAccept -> do newFiles <- fileChooserGetFilenames dialog
                               mapM_ (listStoreAppend listModel) newFiles
    widgetDestroy dialog
    return ()


main :: IO()
main = do
    initGUI
    builder <- builderNew
    builderAddFromFile builder "main.glade"
    addFileButton <- builderGetObject builder castToButton "addFileButton"
    mainWindow <- builderGetObject builder castToWindow "mainWindow"
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

    onClicked addFileButton (addFileToSelectionList mainWindow fileList)

    on mainWindow objectDestroy mainQuit
    widgetShowAll mainWindow
    mainGUI
