{extends file='base/base.tpl'}
{block name="content"}
    {strip}
    <div class="datefilter"><span>Date:</span>
        <ul>
            <li><a id="all" href="#&amp;date=all">All</a></li>
            <li><a id="today" href="#&amp;date=today">Today</a></li>
            <li><a id="tomorrow" href="#&amp;date=tomorrow">Tomorrow</a></li>
            <li><a id="week" href="#&amp;date=week" class="active">Week</a></li>
            <li><a id="month" href="#&amp;date=month">Month</a></li>
        </ul>
    </div>{/strip}

		<ul class="events new" id="eventlist" style="list-style: none">
      {if !$events}
          <li><i>Getting events...</i></li>
      {else}
		    {foreach from=$events item=event}
          <li id="{$event._id}">
            <span class="toprow">
              <a href="{$event.sourceurl}">
                <b>{$event.type}</b> {$event.name}
              </a>
            </span>
            <br>
          </li>
        {/foreach}
      {/if}
		</ul>
{/block}

{block name='map'}
		<div id="mapsection"><br /><br /><br /><br /><br />(No map? The map only works with Javascript turned on.)</div>
{/block}
