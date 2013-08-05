module Main where

import Graphics.UI.Gtk
import Graphics.UI.Gtk.Builder

main = do
    initGUI
    builder <- builderNew
    builderAddFromFile builder "main.glade"
    mainWindow <- builderGetObject builder castToWindow "mainWindow"
    --on mainWindow objectDestroy mainQuit
    widgetShowAll mainWindow
    mainGUI
