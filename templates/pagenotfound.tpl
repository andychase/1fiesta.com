{extends 'base/morebase.tpl'}
{block name='title'}...page not found{/block}
{block name='content'}
<h1 class="centertitle">Oops!</h1>
<h2>The page requested: "{$pageurl}", was not found.</h2>
<h2>Close matches:</h2>
<ul id="id">
{foreach from=$choices key=page item=value}
<li><a href="{$page}" style="font-size: {(6-$value)*4}pt">{$page}</a></li>
{/foreach}
</ul>
<h2>Maybe you were looking for:</h2><br />
<a href="/search/?q=Tigard, OR, USA&type=Location" style="font-size:24pt">What's happening around Tigard, Oregon?</a>
{/block}
