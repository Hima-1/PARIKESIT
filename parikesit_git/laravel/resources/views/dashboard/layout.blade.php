<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" href="{{ asset('img/logo1.png') }}" type="image/x-icon">
    <link rel="stylesheet" href="https://kit-pro.fontawesome.com/releases/v5.12.1/css/pro.min.css">
    <link rel="stylesheet" type="text/css" href="{{ asset('css/style.css') }}">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    {{-- <link href="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.css" rel="stylesheet" /> --}}

    <title>@yield('title', 'New Parikesit')</title>
</head>

<body class="bg-gray-100">


    <!-- start navbar -->
    @include('dashboard.partials.navbar')
    <!-- end navbar -->


    <!-- strat wrapper -->
    <div class="h-screen flex flex-row flex-wrap">

        <!-- start sidebar -->
        @include('dashboard.partials.sidebar')
        <!-- end sidbar -->

        <!-- strat content -->

        <div class="bg-gray-100 flex-1 p-6 md:mt-16">


            {{-- <!-- Sales Overview -->
            <div class="card mt-6">

                <!-- header -->
                <div class="card-header flex flex-row justify-between">
                    <h1 class="h6">Sales Overview</h1>

                    <div class="flex flex-row justify-center items-center">

                        <a href="">
                            <i class="fad fa-chevron-double-down mr-6"></i>
                        </a>

                        <a href="">
                            <i class="fad fa-ellipsis-v"></i>
                        </a>

                    </div>

                </div>
                <!-- end header -->

                <!-- body -->
                <div class="card-body grid grid-cols-2 gap-6 lg:grid-cols-1">

                    <div class="p-8">
                        <h1 class="h2">5,337</h1>
                        <p class="text-black font-medium">Sales this month</p>

                        <div class="mt-20 mb-2 flex items-center">
                            <div class="py-1 px-3 rounded bg-green-200 text-green-900 mr-3">
                                <i class="fa fa-caret-up"></i>
                            </div>
                            <p class="text-black"><span class="num-2 text-green-400"></span><span
                                    class="text-green-400">% more sales</span> in comparison to last month.</p>
                        </div>

                        <div class="flex items-center">
                            <div class="py-1 px-3 rounded bg-red-200 text-red-900 mr-3">
                                <i class="fa fa-caret-down"></i>
                            </div>
                            <p class="text-black"><span class="num-2 text-red-400"></span><span
                                    class="text-red-400">% revenue per sale</span> in comparison to last month.</p>
                        </div>

                        <a href="#" class="btn-shadow mt-6">view details</a>

                    </div>

                    <div class="">
                        <div id="sealsOverview"></div>
                    </div>

                </div>
                <!-- end body -->

            </div>
            <!-- end Sales Overview --> --}}
            @yield('content')


        </div>

        <!-- end content -->

    </div>
    <!-- end wrapper -->

    <!-- script -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    {{-- <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script> --}}
    <script src="{{ asset('js/scripts.js') }}"></script>
    <!-- end script -->

    <script src="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.js"></script>


    @if ($errors->any())
        <script>
            Swal.fire({
                icon: 'error',
                title: 'Error',
                html: `{!! implode('<br>', $errors->all()) !!}`,
            });
        </script>
    @endif

    @if (session()->has('success'))
        <script>
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: '{{ session('success') }}',
            });
        </script>
    @endif

    @if (session()->has('error'))
        <script>
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: '{{ session('error') }}',
            });
        </script>
    @endif

</body>


@stack('scripts')
</body>

</html>
