import {
  ClassSerializerInterceptor,
  Controller,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiTags
} from '@nestjs/swagger';
import {JobDTO} from '../../service/dto/job.dto';
import {JobService} from '../../service/job.service';
import {
  AuthGuard,
  RolesGuard
} from '../../security';
import {LoggingInterceptor} from '../../client/interceptors/logging.interceptor';
import {AbstractBaseController} from "./abstract.base.controller";


@Controller('api/jobs')
@UseGuards(AuthGuard, RolesGuard)
@UseInterceptors(LoggingInterceptor, ClassSerializerInterceptor)
@ApiBearerAuth()
@ApiTags('jobs')
export class JobController extends AbstractBaseController<JobDTO> {
  constructor(
    protected readonly service: JobService,
  ) {
    super(service);
  }
}
