# WiaSpine Spine (Wia-Spine) - Client Project Sandbox

## _A Content-Based Medical Image Retrieval tool for identifying and predicting fragility fractures_

[**A conference paper entitled "Wia-Spine: A CBIR environment with embedded radiomic features to assess fragility fractures" covering Wia-Spine implementation, design and evaluation was submitted to the IEEE 35th International Symposium on Computer Based Medical Systems (CBMS). See the supplementary material here.**](https://github.com/marcosivni/WiaSpine/blob/main/CBMS_Supplementary_Files/Experiments.md)

**WARNING: Wia-Spine is NOT clinical software. It was designed for education and demonstration purposes ONLY!**

Wia-Spine is a Content-Based Medical Image Retrieval (CBIR) tool designed for querying vertebral bodies in spine MRIs.  
The CBIR tool supports JPEG, PNG, BMP, KRL, and DICOM medical images through self-contained 3rd-party libraries. The search mechanism is provided by a server counterpart that supports extended SQL queries (see [The Siren Project][siren]). In addition, an external file server application is used to manage the storage of medical images (see [Websocketfy Project for WiaSpine](https://github.com/marcosivni/websocketfy)).

The implementation of Wia-Spine follows a simplified Model–View–Controller software pattern, where a set of pre-defined tables and classes are employed for accessing and querying medical image records stored on external servers. Therefore, the following steps are required to set up your Wia-Spine application:

1. Configure a SIREN Server and run the DDL creation of its internal tables.
> The SIREN server can be downloaded from [its GitHub entry][siren] and compiled with Qt 5.15.1 basic modules (+ network and SQL). Please note SIREN is **neither** compatible with em++ (Web Assembly) **nor** loaded with its internal tables by default. Please, mind running the Siren DDL (creation) script after installation.

2. Run the [Wia-Spine DDL script][higiiaddl] on the server-side.
> You can use a simple telnet connection (*i.e.*, `telnet <siren-server-ip> <siren-server-port>`) to submit the DDL script that contains standard SQL commands for the creation of the WiaSpine model tables.

3. Structure your medical image dataset as an *WiaSpine table*. Then, create it on the server-side.
> Please, refer to the [HC_LVERT Modelling Guide][model] to see how the HC_LVERT dataset discussed in the CBMS paper was structured.

4. Load your **data** in the new dataset table and the **queries** in the query table.
> Data are inserted with simple extended INSERT INTO commands. See the [example for HC_LVERT radiomic features][model].

5. Run Wia-Spine.
> You can either straightforwardly run the Wia-Spine.html file alongside .wasm and .js loaders or compile the source code with Qt to generate a binary version of Wia-Spine. 

6. ✨Use content-based image retrieval to identify and predict fragility fractures✨

## Background technologies and 3rd-party libraries

Wia-Spine relies on a series of background technologies and 3rd-party libraries, namely:

1. Background technologies 
    - [Qt SDK][qt] - Qt Cross-Platform and SDK C++ development environment. In addition module CHARTS must be downloaded (sudo apt-get install libqt5charts5-dev on Debian-based distros).
    - [Emscripten][ems] - The Open Source Emscripten compiler toolchain (from C++) to WebAssembly. Supported (in some way) by Qt for WebAssembly.

2.  3rd-party libraries (self-contained)
    - [Hermes][hermes] - Our own C++ library of distance functions (and utils).
    - [Artemis][artemis] - Our own wrapper library for images (and utils).
    - [Dicomlib][dicomlib] - The classical self-contained Trevor Morgan dicomlib library from Google Code Archive (We were able to compile it with brand new Emscripten 😀 - Classic codes die hard).
    - [Boost][boost] - A few (self-contained) Boost header files (without the need for compiling the entire library) - wasm-compliant.
    - [Eigen][eigen] - A few (self-contained) Eigen header files (without the need for compiling the entire library) - wasm-compliant.

## Limitations

Known limitations include:

- Absence of SSL authentication due to Web Assembly and QSsl conflicts (See [here](https://bugreports.qt.io/browse/QTBUG-76350)).

## Installation

Install the background technologies and download the source code of 3rd-party libraries.
Then, adjust the include paths of the `WiaSpine.pro.example` file to point to the installation folders of the 3rd-party libraries and rename it to `WiaSpine.pro`.
After that, you can use `build.sh` to compile the client version.
Notice, you can configure the building type of WiaSpine in the `build.sh` file itself by selecting the `qmake` binary of your QT setup (e.g., wasm\_32 (default) or gcc\_64).

```sh
#!/bin/sh
/Qt/5.15.1/wasm_32/bin/qmake   #for Web-Assembly building
#/Qt/5.15.1/gcc_64/bin/qmake   #for desktop-binary building
make
```

Then, run the following command.

```sh
cd WiaSpine
./build.sh && make clean
```

The web version of Wia-Spine requires the browser to support .wasm files loaded through .js (Chrome and Firefox currently support WebAssembly).
Binaries are available at the `/frontend` directory.

## Directory structure

The directory tree is structured as follows.

| Dir | Description |
| ------ | ------ |
| root  | Main functionalities and util. |
| icons | Contains the .png icons of the application. |
| model | Includes DDL creation scripts and examples for the HC_LVERT application. |
| controller | Contains the controller classes for the application. |
| GUI | Contains the form and source code of the application. |
| frontend | Contains a pre-compiled .wasm version of WiaSpine.  |
| 3rd-party  | Includes the entry points for 3rd-party libraries. |


## Notes

_(C) THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OF THIS SOFTWARE OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE._

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format it nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [siren]: <https://github.com/marcosivni/SiREN>
   [higiiaddl]: <https://github.com/marcosivni/WiaSpine/blob/main/model/WiaSpine_DDL.sql>
   [qt]: <https://www.qt.io/download>
   [ws]: <https://github.com/marcosivni/Websocketfy>
   [ems]: <https://emscripten.org/docs/introducing_emscripten/index.html>
   [hermes]: <https://github.com/marcosivni/hermes>
   [artemis]: <https://github.com/marcosivni/artemis>
   [dicomlib]: <https://github.com/marcosivni/dicomlib>
   [boost]: <https://www.boost.org/>
   [eigen]: <https://eigen.tuxfamily.org/>
   [model]: <https://github.com/marcosivni/WiaSpine/blob/main/model/Model.md>
   

![GitHub all releases](https://img.shields.io/github/downloads/marcosivni/higiia/total?style=flat-square)
