using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class PhotosService : BaseService<Photo, PhotoDto, PhotoUpsertDto, BaseSearchObject, IPhotosRepository>, IPhotosService
    {
        public PhotosService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<PhotoUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
