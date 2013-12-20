{extends file='base/htmlbase.tpl'}
{block 'body'}
{strip}
    <div class="navigationbar">
        {include file="nav.tpl"}
    </div>

    <table id="contenttable"><tr id="contentrow"><td id="contentspacer"> </td><td id="contentcolumn">
        <div id="content">
        {block name='content'}

        {/block}
        </div>
        </td><td id="mapcolumn">
		{block name='map'}

		{/block}
        </td></tr>
    </table>
{/strip}
{/block}