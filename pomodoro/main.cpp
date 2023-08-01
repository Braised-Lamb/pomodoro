/*
 * @Author: Braised-Lamb
 * @Email: ygaolamb@gmail.com
 * @Github: https://github.com/Braised-Lamb
 * @Blog: https://braised-lamb.github.io/
 * @Date: 2023-08-01 16:54:14
 * @Last Modified by: Braised-Lamb
 * @Last Modified time: 2023-08-01 16:54:14
 * @Description: main.cpp
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
