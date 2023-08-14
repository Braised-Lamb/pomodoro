/*
 * @Author: Braised-Lamb lambsjtu@outlook.com
 * @Email: ygaolamb@gmail.com
 * @Github: https://github.com/Braised-Lamb
 * @Blog: https://braised-lamb.github.io/
 * @Date: 2023-07-27 18:12:32
 * @LastEditors: Braised-Lamb
 * @LastEditTime: 2023-08-14 17:14:45
 * @FilePath: \pomodoro\pomodoro\main.cpp
 * @Description: 
 * 
 * Copyright (c) 2023 by Braised-Lamb, All Rights Reserved. 
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/imgs/tomato_icon.png"));//…Ë÷√◊¥Ã¨¿∏Õº±Í
    //app.setQuitOnLastWindowClosed(false);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
