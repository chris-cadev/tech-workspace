import inspect
import click
import asyncio
from playwright import async_api


@click.command()
@click.argument('url')
@click.option('-t', '--timeout', default=None, help='Timeout in seconds')
@click.option('-H', '--header', multiple=True, help='HTTP headers in the format "key:value"')
async def fetch_webpage(url, timeout, header):
    headers = {}
    for header_item in header:
        key, value = header_item.split(":")
        headers[key] = value

    for html in fetch_page(url, timeout, headers):
        print(html)


async def fetch_page(url, timeout, headers={}):
    async with async_api() as playwright:
        browser = await playwright.chromium.launch()
        context = await browser.new_context()

        page = await context.new_page()

        await page.goto(url)
        await page.wait_for_load_state("domcontentloaded")

        await page.set_extra_http_headers(headers)

        await asyncio.sleep(float(timeout) if timeout else 0)

        html = await page.content()

        yield html

        await browser.close()

if __name__ == '__main__':
    if inspect.iscoroutinefunction(fetch_webpage):
        task = fetch_webpage()

        res = asyncio.get_event_loop().run_until_complete(task)
