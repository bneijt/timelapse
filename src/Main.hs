module Main where

import Graphics.UI.Gtk
import Graphics.UI.Gtk.Builder

addFileToSelectionList window = do
    dialog <- fileChooserDialogNew Nothing (Just window) FileChooserActionOpen [("Cancel", ResponseCancel), ("Add", ResponseAccept)]
    widgetShow dialog
    response <- dialogRun dialog
    case response of
          ResponseCancel -> putStrLn "You cancelled..."
          ResponseAccept -> do nwf <- fileChooserGetFilename dialog
                               case nwf of
                                    Nothing -> putStrLn "Nothing"
                                    Just path -> putStrLn ("New file path is:\n" ++ path)
    widgetDestroy dialog
    return ()

main :: IO()
main = do
    initGUI
    builder <- builderNew
    builderAddFromFile builder "main.glade"
    addFileButton <- builderGetObject builder castToButton "addFileButton"
    mainWindow <- builderGetObject builder castToWindow "mainWindow"
    onClicked addFileButton (addFileToSelectionList mainWindow)
    on mainWindow objectDestroy mainQuit
    widgetShowAll mainWindow
    mainGUI
