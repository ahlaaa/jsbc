<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单管理</title>
	<%@ include file="/WEB-INF/views/include/headMeta.jsp" %>
    <%@ include file="/WEB-INF/views/include/headCss.jsp" %>
    <%@ include file="/WEB-INF/views/include/headJs.jsp" %>
    <%@ include file="/WEB-INF/views/include/echarts.jsp" %>
</head>
<body>
<!-- 内容-->
<div class="wrapper">
    <!-- 内容盒子-->
    <div class="box box-main">
        <!-- 内容盒子头部 -->
        <div class="box-header">
            <div class="box-title"><i class="fa fa-edit"></i>订单管理</div>
            <div class="box-tools pull-right">
                <a id="btnSearchView" href="#" title="筛选" class="btn btn-default btn-sm"><i
                        class="fa fa-filter"></i>筛选</a>
                <a id="btnRefresh" title="刷新" class="btn btn-default btn-sm"><i class="glyphicon glyphicon-repeat"></i>刷新</a>
                <shiro:hasPermission name="ylttrip:tfTicket:add">
                    <a id="btnAdd" href="${ctx}/ylttrip/tfTicket/form" title="增加" class="btn btn-default btn-sm"><i
                            class="fa fa-plus"></i>增加</a>
                     <a id="btnAdd" href="${ctx}/ylttrip/tfTicket/form?ViewFormType=FormTwo" title="增加2" class="btn btn-default btn-sm"><i
                            class="fa fa-plus"></i>增加2</a>
                </shiro:hasPermission>
                <shiro:hasPermission name="ylttrip:tfTicket:del">
                    <a id="btnDeleteAll" href="${ctx}/ylttrip/tfTicket/deleteAll" title="删除"
                       class="btn btn-default btn-sm"><i class="fa fa-trash-o"></i>删除</a>
                </shiro:hasPermission>
                <a id="btnTotalView" href="#" title="统计" class="btn btn-default btn-sm"><i class="fa fa-file-pdf-o"></i>统计</a>
                <shiro:hasPermission name="ylttrip:tfTicket:import">
                    <table:importExcel url="${ctx}/ylttrip/tfTicket/import"></table:importExcel><!-- 导入按钮 -->
                </shiro:hasPermission>
                <shiro:hasPermission name="ylttrip:tfTicket:export">
                    <table:exportExcel url="${ctx}/ylttrip/tfTicket/export"></table:exportExcel><!-- 导出按钮 -->
                </shiro:hasPermission>
                 <a href="${ctx}/ylttrip/tfTicket/listVue" title="Vue" class="btn btn-default btn-sm"><i
                        class="glyphicon glyphicon-repeat"></i>Vue</a>
                <shiro:hasPermission name="ylttrip:tfTicket:total">
                <a href="${ctx}/ylttrip/tfTicket/total" title="统计图表" class="btn btn-default btn-sm"><i
                            class="glyphicon glyphicon-repeat"></i>统计图表</a>
                 <a href="${ctx}/ylttrip/tfTicket/totalMap" title="统计地图" class="btn btn-default btn-sm"><i
                            class="glyphicon glyphicon-repeat"></i>统计地图</a>
                </shiro:hasPermission>
                     <!-- 工具功能 -->
                    <%@ include file="/WEB-INF/views/include/btnGroup.jsp" %>
                </div>
        </div>
        <!-- 内容盒子身体 -->
        <div class="box-body">
            <!-- 查询条件 -->
            <form:form id="searchForm" modelAttribute="tfTicket" action="${ctx}/ylttrip/tfTicket/" method="post" class="form-inline">
                <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                <input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}"/>
                 <div class="form-group">
                    <span>订单编号：</span>
                        <form:input path="ticketNo" htmlEscape="false" maxlength="25"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>商品编号：</span>
                        <form:input path="goodsNo" htmlEscape="false" maxlength="25"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>种类编号：</span>
                        <form:input path="goodsItemId" htmlEscape="false" maxlength="255"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>种类名称：</span>
                        <form:input path="goodsItemName" htmlEscape="false" maxlength="255"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>商品数量：</span>
                        <form:input path="goodsNum" htmlEscape="false" maxlength="11"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>商品单价：</span>
                        <form:input path="price" htmlEscape="false"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>订单金额：</span>
                        <form:input path="salePrice" htmlEscape="false"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>下单人：</span>
                        <sys:treeselect id="user" name="user.id" value="${tfTicket.user.id}" labelName="user.name" labelValue="${tfTicket.user.name}"
                            title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-sm" allowClear="true" notAllowSelectParent="true"/>
                 </div>
                 <div class="form-group">
                    <span>下单时间：</span>
                        <input id="beginOrderDate" name="beginOrderDate" type="text" maxlength="20" class="laydate-icon form-control layer-date input-sm"
                            value="<fmt:formatDate value="${tfTicket.beginOrderDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/> -
                        <input id="endOrderDate" name="endOrderDate" type="text" maxlength="20" class="laydate-icon form-control layer-date input-sm"
                            value="<fmt:formatDate value="${tfTicket.endOrderDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
                 </div>
                 <div class="form-group">
                    <span>订单状态：</span>
                        <form:radiobuttons class="i-checks" path="state" items="${fns:getDictListAddAll('STATE')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                 </div>
                 <div class="form-group">
                    <span>状态时间：</span>
                        <input id="beginStateDate" name="beginStateDate" type="text" maxlength="20" class="laydate-icon form-control layer-date input-sm"
                            value="<fmt:formatDate value="${tfTicket.beginStateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/> -
                        <input id="endStateDate" name="endStateDate" type="text" maxlength="20" class="laydate-icon form-control layer-date input-sm"
                            value="<fmt:formatDate value="${tfTicket.endStateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
                 </div>
                 <div class="form-group">
                    <span>客户姓名：</span>
                        <form:input path="custName" htmlEscape="false" maxlength="50"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>联系电话：</span>
                        <form:input path="linkPhone" htmlEscape="false" maxlength="50"  class=" form-control input-sm"/>
                 </div>
                 <div class="form-group">
                    <span>付款方式：</span>
                        <form:radiobuttons class="i-checks" path="payType" items="${fns:getDictListAddAll('PAY_TYPE')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                 </div>
                 <div class="form-group">
                    <button id="btnSearch" class="btn btn-primary"><i class="fa fa-search"></i> 查询</button>
                    <button id="btnReset" class="btn btn-default"><i class="fa fa-refresh"></i> 重置</button>
                </div>
            </form:form>

            <!-- 表格 -->
            <table id="contentTable" class="table table-hover table-condensed dataTables-example dataTable">
                <thead>
                    <tr>
                        <th> <input type="checkbox" class="i-checks"></th>
                        <th  class="sort-column ticketNo ">订单编号</th>
                        <th  class="sort-column goodsNo ">商品编号</th>
                        <th  class="sort-column goodsItemId ">种类编号</th>
                        <th  class="sort-column goodsItemName hidden-xs">种类名称</th>
                        <th  class="sort-column goodsNum hidden-xs">商品数量</th>
                        <th  class="sort-column price hidden-xs">商品单价</th>
                        <th  class="sort-column salePrice hidden-xs">订单金额</th>
                        <th  class="sort-column user.name hidden-xs">下单人</th>
                        <th  class="sort-column linkPhone hidden-xs">联系电话</th>
                        <th  class="sort-column payType hidden-xs">付款方式</th>
                        <th  class="sort-column checkinCode hidden-xs">入园号</th>
                        <th  class="sort-column reserveId hidden-xs">票务系统订单号</th>
                        <th  class="sort-column remark hidden-xs">订单备注</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="tfTicket">
                    <tr>
                        <td>
                        <input type="checkbox" id="${tfTicket.id}"
                            ticketNo="${tfTicket.ticketNo}"
                            goodsNo="${tfTicket.goodsNo}"
                            goodsItemId="${tfTicket.goodsItemId}"
                            goodsItemName="${tfTicket.goodsItemName}"
                            goodsNum="${tfTicket.goodsNum}"
                            price="${tfTicket.price}"
                            salePrice="${tfTicket.salePrice}"
                            user.id="${tfTicket.user.id}"
                            linkPhone="${tfTicket.linkPhone}"
                            payType="${tfTicket.payType}"
                            checkinCode="${tfTicket.checkinCode}"
                            reserveId="${tfTicket.reserveId}"
                        class="i-checks"></td>
                        <td class=""><a  href="${ctx}/ylttrip/tfTicket/form?id=${tfTicket.id}&action=view">
                            ${tfTicket.ticketNo}
                        </a></td>
                        <td class="">
                            ${tfTicket.goodsNo}
                        </td>
                        <td class="">
                            ${tfTicket.goodsItemId}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.goodsItemName}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.goodsNum}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.price}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.salePrice}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.user.name}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.linkPhone}
                        </td>
                        <td class="hidden-xs">
                            ${fns:getDictLabel(tfTicket.payType, 'PAY_TYPE', '')}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.checkinCode}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.reserveId}
                        </td>
                        <td class="hidden-xs">
                            ${tfTicket.remark}
                        </td>
                        <td>
                            <shiro:hasPermission name="ylttrip:tfTicket:view">
                                <a href="${ctx}/ylttrip/tfTicket/form?id=${tfTicket.id}&action=view" title="查看"><i class="fa fa-search-plus"></i></a>
                            </shiro:hasPermission>
                             <shiro:hasPermission name="ylttrip:tfTicket:edit">
                                <a href="${ctx}/ylttrip/tfTicket/form?id=${tfTicket.id}" title="修改"  title="修改"><i class="fa fa-pencil"></i></a>
                            </shiro:hasPermission>
                            <shiro:hasPermission name="ylttrip:tfTicket:del">
                                <a href="${ctx}/ylttrip/tfTicket/delete?id=${tfTicket.id}" onclick="return confirmx('确认要删除该订单吗？', this.href)" title="删除"><i class="fa fa-trash-o"></i></a>
                            </shiro:hasPermission>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <!-- 分页代码 -->
            ${page.toStringPage()}
            <!-- 统计 -->
            <div class="row" id="total" style="margin-top: 10px;">
                <div class="col-sm-12 echartsEval">
                    <h4>合计：${sumTotalCount}行;
                    商品数量：${sumGoodsNum};
                    商品单价：${sumPrice};
                    订单金额：${sumSalePrice};
                    </h4>
                    <div id="pie"  class="main000"></div>
                    <echarts:pie
                            id="pie"
                            title="订单数量饼图"
                            subtitle="订单数量饼图"
                            orientData="${orientData}"/>
                    <!--div id="pieSumGoodsNum"  class="main000"></div-->
                    <!--xxx-echarts:pie
                            id="pieSumGoodsNum"
                            title="订单商品数量饼图"
                            subtitle="订单商品数量饼图"
                            orientData="${orientDataSumGoodsNum}"/-->
                    <!--div id="pieSumPrice"  class="main000"></div-->
                    <!--xxx-echarts:pie
                            id="pieSumPrice"
                            title="订单商品单价饼图"
                            subtitle="订单商品单价饼图"
                            orientData="${orientDataSumPrice}"/-->
                    <!--div id="pieSumSalePrice"  class="main000"></div-->
                    <!--xxx-echarts:pie
                            id="pieSumSalePrice"
                            title="订单订单金额饼图"
                            subtitle="订单订单金额饼图"
                            orientData="${orientDataSumSalePrice}"/-->

                    <div id="line_normal"  class="main000"></div>
                    <echarts:line
                    id="line_normal"
                    title="订单曲线"
                    subtitle="订单曲线"
                    xAxisData="${xAxisData}"
                    yAxisData="${yAxisData}"
                    xAxisName="时间"
                    yAxisName="数量" />
                </div>
            </div>
            <!-- 统计 end-->
        </div>
	</div>
</div>
<!-- 信息-->
<div id="messageBox">${message}</div>
<script src="/staticViews/viewBase.js"></script>
<script src="/staticViews/modules/ylttrip//tfTicketList.js" type="text/javascript"></script>
<link href="/staticViews/modules/ylttrip/tfTicketList.css" rel="stylesheet" />
</body>
</html>