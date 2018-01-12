/*
 * Copyright (c) 2018 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package;

import kha.System;
import jasper.*;
import ui.Window;

class Main {
    public static function main() : Void
    {
        var _width :Float = 780;
        var _height :Float = 400;
        var solver = new Solver();
        _baseWindow = new Window(0xff3333ff, PX(10, Strength.WEAK), PX(20, Strength.WEAK), PX(780, Strength.WEAK), PX(400, Strength.WEAK));
        _baseWindow
            .addWindow(new Window(0xfff0ff33, PERCENT(0.25, Strength.MEDIUM), PERCENT(0.25, Strength.MEDIUM), PERCENT(0.5, Strength.MEDIUM), PERCENT(0.5, Strength.MEDIUM)))
            .addWindow(new Window(0xff00ff33, PERCENT(0.25, Strength.MEDIUM), PX(0, Strength.MEDIUM), PERCENT(0.5, Strength.MEDIUM), PERCENT(0.5, Strength.MEDIUM))
                .addWindow(new Window(0xff007f33, PERCENT(0.25, Strength.MEDIUM), PERCENT(0.25, Strength.MEDIUM), PERCENT(0.5, Strength.MEDIUM), PERCENT(0.5, Strength.MEDIUM))));

        _baseWindow.addToSolver(solver);
        solver.updateVariables();

        _baseWindow.makeEdit(solver);
        

        System.init({title: "jasper-example", width: 1366, height: 768}, function() {
            System.notifyOnRender(render);

            var _isDown :Bool = false;
            kha.input.Mouse.get().notify(function(a,x,y) {
                _isDown = true;
            }, function(a,x,y) {
                _isDown = false;

            }, function(x,y,c,d) {
                if(_isDown) {
                    _baseWindow.setSize(x, y, solver);
                }
                
            }, function(a) {

            });
        });
    }

    public static function render(framebuffer: kha.Framebuffer): Void 
    {
        framebuffer.g2.begin();
        _baseWindow.render(framebuffer);
        framebuffer.g2.end();
	}

    static var _baseWindow :Window;
}