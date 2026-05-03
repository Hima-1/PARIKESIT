<div id="sideBar"
    class="relative flex flex-col flex-wrap bg-white border-r border-gray-300 p-6 flex-none w-64 md:-ml-64 md:fixed md:top-0 md:z-30 md:h-screen md:shadow-xl animated faster">


    <!-- sidebar content -->
    <div class="flex flex-col">

        <!-- sidebar toggle -->
        <div class="text-right hidden md:block mb-4">
            <button id="sideBarHideBtn">
                <i class="fad fa-times-circle"></i>
            </button>
        </div>
        <!-- end sidebar toggle -->

        <p class="uppercase text-xs text-gray-600 mb-4 tracking-wider">homes</p>

        <!-- link -->


        <a href="/"
            class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('home')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
            <i class="fad fa-chart-pie text-xs mr-2"></i>
            Beranda
        </a>

        <!-- end link -->

        @if (Auth::user()->role == 'admin')
            <!-- link -->
            <a href="{{ route('user.index') }}"
                class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('user.*')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
                <i class="fad fa-user text-xs mr-2"></i>
                Manajemen User
            </a>
            <!-- end link -->

            <a href="{{ route('opd-notifications.index') }}"
                class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('opd-notifications.*')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
                <i class="fad fa-bell text-xs mr-2"></i>
                Notifikasi OPD
            </a>
        @endif

        <p class="uppercase text-xs text-gray-600 mb-4 mt-4 tracking-wider">Penilaian</p>


        @if (Auth::user()->role == 'opd')
        <a href="{{ route('formulir.index') }}"
            class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('formulir.*') && !request()->routeIs('formulir.penilaianTersedia') && !request()->routeIs('formulir.domain-penilaian') && !request()->routeIs('formulir.isi-domain') && !request()->routeIs('formulir.penilaianAspek')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
            <i class="fad fa-folder text-xs mr-2"></i>
            Formulir
        </a>
    @endif
        @if (Auth::user()->role == 'opd')
            <!-- link -->
            <a href="{{ route('penilaian.index') }}"
                class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('penilaian.*') || request()->routeIs('formulir.penilaianTersedia') || request()->routeIs('formulir.domain-penilaian') || request()->routeIs('formulir.isi-domain') || request()->routeIs('formulir.penilaianAspek')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
                <i class="fad fa-tasks text-xs mr-2"></i>
                Isi Formulir
            </a>
        @endif


            {{-- @if (Auth::user()->role == 'admin' || Auth::user()->role == 'walidata') --}}
            <a href="{{ route('disposisi.penilaian.tersedia') }}"
                class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('disposisi.penilaian.tersedia')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
                <i class="fad fa-check-circle text-xs mr-2"></i>
                Penilaian Selesai
            </a>
        {{-- @endif --}}





        <p class="uppercase text-xs text-gray-600 mb-4 mt-4 tracking-wider">Dokumentasi</p>

        <a href="{{ route('dokumentasi.index') }}"
            class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('dokumentasi.*')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
            <i class="fad fa-camera text-xs mr-2"></i>
            Dokumentasi Kegiatan
        </a>
        <!-- end link -->
        @if (Auth::user()->role == 'admin')
            <a href="{{ route('pembinaan.index') }}"
                class="py-1 px-2 mb-3 capitalize font-medium text-sm hover:text-teal-600 transition ease-in-out duration-500 {{ (request()->routeIs('pembinaan.*')) ? 'text-teal-600 bg-gray-300 border-1 border-gray-500 rounded-lg shadow' : '' }}">
                <i class="fad fa-whistle text-xs mr-2"></i>
                Pembinaan
            </a>
        @endif






    </div>
    <!-- end sidebar content -->

</div>
