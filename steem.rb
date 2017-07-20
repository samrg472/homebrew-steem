class Steem < Formula
  desc "Steemit is a blockchain-powered social media platform."
  homepage "https://steemit.com/"
  url "https://github.com/steemit/steem.git",
    :tag => "v0.19.0",
    :revision => "1ad862ef3132b9cfcba63ca823f7c3391c0f8580"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "python3" => :build
  depends_on "doxygen" => :optional
  depends_on "boost@1.60"
  depends_on "openssl"

  # Patches to fix compiler error: invalid partial specialization
  patch do
    url "https://raw.githubusercontent.com/samrg472/homebrew-steem/master/patches/static_variant.hpp.diff"
    sha256 "ae56c6494baf329afa8daee402e35de0627d71b0ab1f1ab0b5cca104c3516eb7"
  end

  patch do
    url "https://raw.githubusercontent.com/samrg472/homebrew-steem/master/patches/schema_impl.hpp.diff"
    sha256 "2cc42f4e17902fdaac71bec538b884e45098df75cddff345e3cca0d3b9a5ddbc"
  end

  patch do
    url "https://raw.githubusercontent.com/samrg472/homebrew-steem/master/patches/js_operation_serializer-main.cpp.diff"
    sha256 "fe3ec064bd483f4fc1a1221b986ee95c8e693cbb2e0c1006e0699137ad798795"
  end

  # Patch to fix doxygen docs
  patch do
    url "https://raw.githubusercontent.com/samrg472/homebrew-steem/master/patches/generate_api_documentation.pl.diff"
    sha256 "1cd6ade519e097fe3d9837b5de0a842b0162360e7962c933244af95ade4ecf9d"
  end

  def install
    cmake_args = %W[
      CMakeLists.txt
      -DCMAKE_INSTALL_PREFIX="#{prefix}"
      -DCMAKE_BUILD_TYPE=Release
    ]

    system "pip3", "install", "jinja2"
    system "cmake", *(cmake_args + std_cmake_args)
    system "make", "install"

    # Prevent double symlinking
    rm_r "#{lib}/cmake"
  end

  test do
    system "#{bin}/steemd", "-h"
  end
end
