import {
  Body,
  ClassSerializerInterceptor,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
  Req,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags
} from '@nestjs/swagger';
import {JobDTO} from '../../service/dto/job.dto';
import {
  Page,
  PageRequest
} from '../../domain/base/pagination.entity';
import {
  AuthGuard,
  Roles,
  RolesGuard,
  RoleType
} from '../../security';
import {HeaderUtil} from '../../client/header-util';
import {Request} from '../../client/request';
import {LoggingInterceptor} from '../../client/interceptors/logging.interceptor';
import {AbstractBaseService} from '../../service/abstract.base.service';
import {BaseDTO} from "../../service/dto/base.dto";

@Controller('api/jobs')
@UseGuards(AuthGuard, RolesGuard)
@UseInterceptors(LoggingInterceptor, ClassSerializerInterceptor)
@ApiBearerAuth()
@ApiTags('jobs')
export class AbstractBaseController<D extends BaseDTO> {

  constructor(protected readonly service: AbstractBaseService<any, any>) {
  }

  @Get('/')
  @Roles(RoleType.USER)
  @ApiResponse({
    status: 200,
    description: 'List all records',
    type: "DTO[]",
  })
  async getAll(@Req() req: Request): Promise<D[]> {
    const pageRequest: PageRequest = new PageRequest(req.query.page, req.query.size, req.query.sort);
    const [results, count] = await this.service.findAndCount({
      skip: +pageRequest.page * pageRequest.size,
      take: +pageRequest.size,
      order: pageRequest.sort.asOrder(),
    });
    HeaderUtil.addPaginationHeaders(req.res, new Page(results, count, pageRequest));
    return results;
  }

  @Get('/_search')
  @Roles(RoleType.ADMIN)
  @ApiOperation({summary: 'Search entity (default)'})
  @ApiResponse({
    status: 200,
    description: 'Search all records by keywords.',
    type: "DTO[]",
  })
  @ApiResponse({status: 403, description: 'Forbidden.'})
  async search(@Req() req: Request,@Query("keywords") keywords: string): Promise<D[]> {
    const results = await this.service.search(keywords);
    HeaderUtil.addEntityCreatedHeaders(req.res, 'Job', results);
    return results;
  }

  @Get('/:id')
  @Roles(RoleType.USER)
  @ApiResponse({
    status: 200,
    description: 'The found record',
    type: "DTO",
  })
  async getOne(@Param('id') id: number): Promise<D> {
    return this.service.findById(id);
  }

  @Post('/')
  @Roles(RoleType.ADMIN)
  @ApiOperation({summary: 'Create entity (default)'})
  @ApiResponse({
    status: 201,
    description: 'The record has been successfully created.',
    type: "DTO",
  })
  @ApiResponse({status: 403, description: 'Forbidden.'})
  async post(@Req() req: Request, @Body() dto: D): Promise<D> {
    const created = await this.service.save(dto, req.user?.login);
    HeaderUtil.addEntityCreatedHeaders(req.res, 'Job', created.id);
    return created;
  }

  @Put('/')
  @Roles(RoleType.ADMIN)
  @ApiOperation({summary: 'Update entity (default)'})
  @ApiResponse({
    status: 200,
    description: 'The record has been successfully updated.',
    type: "DTO",
  })
  async put(@Req() req: Request, @Body() dto: D): Promise<JobDTO> {
    HeaderUtil.addEntityCreatedHeaders(req.res, 'Job', dto.id);
    return this.service.update(dto, req.user?.login);
  }

  @Put('/:id')
  @Roles(RoleType.ADMIN)
  @ApiOperation({summary: 'Update entity with id (default)'})
  @ApiResponse({
    status: 200,
    description: 'The record has been successfully updated.',
    type: "DTO",
  })
  async putId(@Req() req: Request, @Body() dto: D): Promise<D> {
    HeaderUtil.addEntityCreatedHeaders(req.res, 'Job', dto.id);
    return this.service.update(dto, req.user?.login);
  }

  @Delete('/:id')
  @Roles(RoleType.ADMIN)
  @ApiOperation({ summary: 'Delete entity (default)' })
  @ApiResponse({
    status: 204,
    description: 'The record has been successfully deleted.',
  })
  async deleteById(@Req() req: Request, @Param('id') id: number): Promise<void> {
    HeaderUtil.addEntityDeletedHeaders(req.res, 'Job', id);
    return this.service.deleteById(id);
  }
}
