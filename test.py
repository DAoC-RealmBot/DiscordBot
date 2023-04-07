import asyncio

async def sleep_example():
    print("Start sleeping")
    await asyncio.sleep(5)
    print("Finished sleeping")

async def print_after_delay():
    print('2')

async def main():
    await sleep_example()

async def run_coroutines():
    main_task = asyncio.create_task(main())
    #print_task = asyncio.create_task(print_after_delay())
    await asyncio.gather(main_task)

print('1')
asyncio.run(run_coroutines())
print('2')