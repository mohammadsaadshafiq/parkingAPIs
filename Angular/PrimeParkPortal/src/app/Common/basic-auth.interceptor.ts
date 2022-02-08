// import { Injectable } from '@angular/core';
// import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor } from '@angular/common/http';
// import { Observable } from 'rxjs';

// import { AuthenticationService } from '../login/authentication-.service';

// @Injectable()
// export class BasicAuthInterceptor implements HttpInterceptor {
//     constructor(private authenticationService: AuthenticationService) { }

//     intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
//         // add authorization header with basic auth credentials if available
//         // const currentUser = this.authenticationService.currentUserValue;
//          if (localStorage.getItem('currentUser') && localStorage.getItem('flag')) {
//             request = request.clone({
//                 setHeaders: {
//                     'x-access-token': this.authenticationService.currentUserValue.data.token,
//                     'Access-Control-Allow-Origin' : '*',
//                     'Content-Type': 'application/json',
//                     'Channel': 'MTA',
//                 }
//             });
//         }
//        else if (localStorage.getItem('currentUser')) {
//             request = request.clone({
//                 setHeaders: {
//                     Authorization: `Basic ${localStorage.getItem('currentUser')}`,
//                     'Access-Control-Allow-Origin' : '*',
//                     'Content-Type': 'application/json',
//                     'Channel': 'MTA',
//                 }
//             });
//         }
//          return next.handle(request);
//     }
// }