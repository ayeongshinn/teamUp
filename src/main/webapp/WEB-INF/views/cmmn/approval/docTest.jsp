<!DOCTYPE html>
<html>
<head>
    <!-- jQuery 및 Fancytree 로드 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.fancytree/2.38.2/jquery.fancytree-all-deps.min.js?v=1.0"></script>
    <style type="text/css"></style>
</head>
<!-- Fancytree 초기화 -->
<script type="text/javascript">
var $ = jQuery.noConflict();
    $(document).ready(function() {
    	console.log(jQuery.fn.jquery);
        $("#tree").fancytree({
            source: $.ui.fancytree.parseHtml($("#treeData"))
        });
    });
</script>
<body>
    <div id="tree"></div> <!-- 트리가 표시될 div -->
    
    <!-- 트리 데이터 -->
    <ul id="treeData" style="display: none;">
        <li id="id1" title="Look, a tool tip!">item1 with key and tooltip</li>
        <li id="id2">item2</li>
        <li id="id3" class="folder">Folder <em>with some</em> children
            <ul>
                <li id="id3.1">Sub-item 3.1
                    <ul>
                        <li id="id3.1.1">Sub-item 3.1.1</li>
                        <li id="id3.1.2">Sub-item 3.1.2</li>
                        <li id="id3.1.3">Sub-item 3.1.3</li>
                    </ul>
                </li>
                <li id="id3.2">Sub-item 3.2
                    <ul>
                        <li id="id3.2.1">Sub-item 3.2.1</li>
                        <li id="id3.2.2">Sub-item 3.2.2</li>
                    </ul>
                </li>
            </ul>
        </li>
        <li id="id4" class="expanded">Document with some children (expanded on init)
            <ul>
                <li id="id4.1" class="active focused">Sub-item 4.1 (active and focus on init)
                    <ul>
                        <li id="id4.1.1">Sub-item 4.1.1</li>
                        <li id="id4.1.2">Sub-item 4.1.2</li>
                    </ul>
                </li>
                <li id="id4.2">Sub-item 4.2
                    <ul>
                        <li id="id4.2.1">Sub-item 4.2.1</li>
                        <li id="id4.2.2">Sub-item 4.2.2</li>
                    </ul>
                </li>
            </ul>
        </li>
    </ul>
</body>
</html>
